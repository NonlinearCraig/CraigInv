(* ::Package:: *)

BeginPackage["BCDC2`"];

(* ============================================================*)
(*1. Public Function and Protocol Declarations*)
(* ============================================================*)

MainMultiRefactored::usage="MainMultiRefactored[spec] runs the multi-branch barrier certificate generation and verification.";
PreprocessProblem::usage="PreprocessProblem[spec] normalizes and reduces polynomials.";
InitSosState::usage="InitSosState[varSet, invWork] initializes the SOS constraint state association.";
AddInitializationConstraints::usage="AddInitializationConstraints[problem, sosState, wideg] encodes the initial constraints.";
AddExitConstraints::usage="AddExitConstraints[problem, sosState, epsilon, wideg] encodes the exit safety constraints.";
AddBranchInductivenessConstraints::usage="AddBranchInductivenessConstraints[problem, sosState, epsilon, wideg] encodes the loop inductiveness.";
InvTemp::usage="InvTemp[vars, order] generates a polynomial template with 1D subscript coefficients (a).";
polyTemp::usage="polyTemp[vars, order, typeSymbol, id] generates multiplier polynomial with 2D subscript coefficients.";
BuildGramConstraintData::usage="BuildGramConstraintData[sosState, lambda, verbose] builds and decomposes Gram matrices.";
SolveBySequentialSDP::usage="SolveBySequentialSDP[gramData, lambda, problem] executes the iterative SDP solving process.";
VerifyCertificate::usage="VerifyCertificate[spec, pData, B] uses FindInstance to rigorously verify the synthesized barrier.";

(*Canonical protocol symbols*)
a::usage="a is the canonical symbol for barrier coefficients.";
b::usage="b is the canonical symbol for general multiplier coefficients.";
v::usage="v is the canonical symbol for branch multiplier coefficients.";

BarrierVarQ::usage="BarrierVarQ[v] tests if v is a barrier coefficient (a).";
MultiplierVarQ::usage="MultiplierVarQ[v] tests if v is a multiplier coefficient (b or v).";
NormalizePointRules::usage="NormalizePointRules[rules] normalizes variable substitutions.";
BuildSolverVariableBundle::usage="BuildSolverVariableBundle[vars, lambda] returns a normalized initial rule set.";
ExtractDecisionVarsCanonical::usage="ExtractDecisionVarsCanonical[expr] extracts only valid barrier and multiplier coefficients.";
decomposeConstraintData::usage="decomposeConstraintData[cMatrix, lambda, verbose] performs variable separation and matrix classification.";
buildLinearizedConstraint::usage="buildLinearizedConstraint[data, ptRules] constructs the Taylor expansion matrix at a given point.";

Begin["`Private`"];

(* ============================================================*)
(*2. Variable Protocol& Canonical Extractor*)
(* ============================================================*)

(*Check for barrier coefficients:1D subscript (a_i)*)
BarrierVarQ[var_]:=MatchQ[var,Subscript[a,_Integer]];

(*Check for multiplier coefficients:2D subscript (b_{id,i} or v_{id,i})*)
MultiplierVarQ[var_]:=MatchQ[var,Subscript[b|v,_Integer,_Integer]];

(*Canonical extractor:Filters out state variables,retaining only decision variables*)
ExtractDecisionVarsCanonical[expr_]:=Select[Variables[Flatten[{expr}]],BarrierVarQ[#]||MultiplierVarQ[#]&];

(* ============================================================*)
(*3. Heuristic Initialization& Rule Normalization*)
(* ============================================================*)

BuildSolverVariableBundle[vars_List,lambda_Symbol]:=Thread[vars->Replace[vars,{lambda->1.0,(*Prevent self-loop,assign deterministic initial value to slack variable*)Subscript[v,_,1]->-1.0,(*Branch multiplier constant term assigned negative to guide search*)Subscript[b,_,1]->1.0,(*General constraint multiplier constant term assigned positive*)Subscript[b|v,_,_]->0.0,(*Higher-order multiplier terms assigned 0*)Subscript[a,_]->0.1,(*Barrier coefficients assigned small positive values to break symmetry*)_->0.1                          (*Fallback safety net*)},{1}]];

NormalizePointRules[rule_Rule]:=If[ListQ[rule[[1]]]&&ListQ[rule[[2]]],Thread[rule],{rule}];
NormalizePointRules[rules_List]:=Flatten[NormalizePointRules/@rules];
NormalizePointRules[other_]:=other;

toPolyList[e_]:=Flatten[{e}];
zeroPolyQ[p_]:=TrueQ[Expand[p]===0]||TrueQ[PossibleZeroQ[Expand[p]]];
symmetrizeMatrix[m_]:=(m+Transpose[m])/2;

(* ============================================================*)
(*4. Polynomial Template Generators*)
(* ============================================================*)

InvTemp[vars_List,order_Integer]:=Module[{idx},idx=Select[Tuples[Range[0,order],Length[vars]],Total[#]<=order&];
(Times@@@(vars^#&/@idx)) . Table[Subscript[a,i],{i,1,Length[idx]}]];

polyTemp[vars_List,order_Integer,typeSymbol_Symbol,id_Integer]:=Module[{idx,coefVars},idx=Select[Tuples[Range[0,order],Length[vars]],Total[#]<=order&];
coefVars=Table[Subscript[typeSymbol,id,i],{i,1,Length[idx]}];
{(Times@@@(vars^#&/@idx)) . coefVars,coefVars}];

normalizeEqPolys[zVars_List:{},equalities_:{}]:=Module[{eqs=Flatten[{equalities}]},If[eqs==={},Return[{}]];
Table[Which[MatchQ[eqs[[i]],_Equal],Expand[eqs[[i,1]]-eqs[[i,2]]],zVars=!={}&&i<=Length[zVars],Expand[zVars[[i]]-eqs[[i]]],True,Expand[eqs[[i]]]],{i,Length[eqs]}]];

encodeImplication[premises_List,conclusion_,sosState_Association,epsilon_,wideg_,prefixFirst_Symbol]:=Module[{vars,sdpVar,constraints,multipliers,multiplierCoefs,nextId,index,sum=0,poly,coef,i,newState=sosState,currentType},vars=newState["Vars"];sdpVar=newState["DecisionVars"];
constraints=newState["Constraints"];multipliers=newState["Multipliers"];
multiplierCoefs=newState["MultiplierCoefs"];nextId=newState["NextId"];
index=newState["Index"];
For[i=1,i<=Length[premises],i++,currentType=If[i==1,prefixFirst,b];
{poly,coef}=polyTemp[vars,wideg,currentType,nextId];
AppendTo[multipliers,poly];AppendTo[multiplierCoefs,coef];
AppendTo[constraints,poly];sdpVar=Join[sdpVar,coef];
AppendTo[index,nextId];
sum=Collect[ExpandAll[sum+poly*premises[[i]]],vars,Simplify];
nextId++;];
AppendTo[constraints,Collect[ExpandAll[conclusion-sum-epsilon],vars,Simplify]];
nextId++;
<|"Vars"->vars,"DecisionVars"->sdpVar,"Constraints"->constraints,"Multipliers"->multipliers,"MultiplierCoefs"->multiplierCoefs,"NextId"->nextId,"Index"->index|>];

(* ============================================================*)
(*5. Core Problem Preprocessing& Constraint Assembly*)
(* ============================================================*)

PreprocessProblem[spec_Association]:=Module[{varSet=spec["varSet"],inv=spec["inv"],xBound=spec["xBound"],preList=Lookup[spec,"preList",{}],negPostList=Lookup[spec,"negPostList",{}],guard=Lookup[spec,"guard",{}],branchCondList=Lookup[spec,"branchCondList",{}],branchPxList=Lookup[spec,"branchPxList",{}],zVars=Lookup[spec,"zVars",{}],equalities=Lookup[spec,"equalities",{}],equalityMode=Lookup[spec,"equalityMode","Reduce"],eqPolys,eqPairs,gb,red,boundList},If[Length[branchCondList]=!=Length[branchPxList],Return[$Failed]];
eqPolys=normalizeEqPolys[zVars,equalities];
eqPairs=Join[eqPolys,-eqPolys];
Switch[equalityMode,"Reduce",gb=If[eqPolys==={},{},GroebnerBasis[eqPolys,varSet]];red=If[eqPolys==={},Expand,(Expand[Last[PolynomialReduce[Expand[#],gb,varSet]]]&)];,"ExactPair",red=Expand;,_,Return[$Failed];];
boundList=Flatten[Map[{#-xBound[[1]],xBound[[2]]-#}&,varSet]];
<|"varSet"->varSet,"invWork"->red[inv],"preListWork"->red/@toPolyList[preList],"negPostListWork"->red/@toPolyList[negPostList],"guardListWork"->red/@toPolyList[guard],"branchCondListWork"->Map[red,toPolyList/@branchCondList,{2}],"branchPxList"->branchPxList,"eqPolys"->eqPolys,"eqPairs"->eqPairs,"boundList"->boundList,"equalityMode"->equalityMode,"redFunc"->red|>];

InitSosState[varSet_,invWork_]:=<|"Vars"->varSet,"DecisionVars"->ExtractDecisionVarsCanonical[invWork],"Constraints"->{},"Multipliers"->{},"MultiplierCoefs"->{},"NextId"->1,"Index"->{}|>;

AddInitializationConstraints[problem_,sosState_,wideg_]:=Module[{newState=sosState,pretemp,i,t},For[i=1,i<=Length[problem["preListWork"]],i++,pretemp=Flatten[Join[{problem["preListWork"][[i]]},problem["boundList"]]];
newState=encodeImplication[pretemp,problem["invWork"],newState,0,wideg,b];
For[t=1,t<=Length[problem["eqPairs"]],t++,newState=encodeImplication[pretemp,problem["eqPairs"][[t]],newState,0,wideg,b];];];
newState];

AddExitConstraints[problem_,sosState_,epsilon_,wideg_]:=Module[{newState=sosState,eqAdd,posttemp,j,k},eqAdd=If[problem["equalityMode"]==="ExactPair",problem["eqPairs"],{}];
If[Length[problem["guardListWork"]]==0,For[j=1,j<=Length[problem["negPostListWork"]],j++,posttemp=Join[{problem["negPostListWork"][[j]]},problem["boundList"],eqAdd];
newState=encodeImplication[posttemp,-problem["invWork"],newState,epsilon,wideg,b];],For[j=1,j<=Length[problem["negPostListWork"]],j++,For[k=1,k<=Length[problem["guardListWork"]],k++,posttemp=Join[{problem["negPostListWork"][[j]],-problem["guardListWork"][[k]]},problem["boundList"],eqAdd];
newState=encodeImplication[posttemp,-problem["invWork"],newState,epsilon,wideg,b];];];];
newState];

AddBranchInductivenessConstraints[problem_,sosState_,epsilon_,wideg_]:=Module[{newState=sosState,loopPremises,targetPolys,eqPostReduced,i,t,eqAdd},eqAdd=If[problem["equalityMode"]==="ExactPair",problem["eqPairs"],{}];
For[i=1,i<=Length[problem["branchPxList"]],i++,loopPremises=Join[{problem["invWork"]},problem["boundList"],problem["guardListWork"],problem["branchCondListWork"][[i]],eqAdd];
If[problem["equalityMode"]==="Reduce",targetPolys={problem["redFunc"][problem["invWork"]/. Thread[problem["varSet"]->problem["branchPxList"][[i]]]]};
eqPostReduced=Select[problem["redFunc"]/@(problem["eqPolys"]/. Thread[problem["varSet"]->problem["branchPxList"][[i]]]),Not[zeroPolyQ[#]]&];
targetPolys=Join[targetPolys,Flatten[({#,-#}&/@eqPostReduced)]],targetPolys=Join[{Expand[problem["invWork"]/. Thread[problem["varSet"]->problem["branchPxList"][[i]]]]},Expand/@(problem["eqPairs"]/. Thread[problem["varSet"]->problem["branchPxList"][[i]]])]];
For[t=1,t<=Length[targetPolys],t++,newState=encodeImplication[loopPremises,targetPolys[[t]],newState,If[t==1,epsilon,0],wideg,v];];];
newState];

(* ============================================================*)
(*6. Gram Matrix Decomposition& Classification*)
(* ============================================================*)

polyDegree[poly_,vars_]:=Max[0,Max[Total/@Keys[Quiet@CoefficientRules[Expand[poly],vars]]/. {}->{0}]];
monomList[vars_,degree_]:=Module[{n=Length[vars]},Times@@@(vars^#&/@Select[Tuples[Range[0,degree],n],Total[#]<=degree&])];

coefficientMatrix[vars_,basis_,poly_]:=Module[{n=Length[basis],qVars,A,eqns,sol,rules},qVars=Table[Unique["q$"],{n},{n}];
A=Table[If[i<=j,qVars[[i,j]],qVars[[j,i]]],{i,n},{j,n}];
eqns=Thread[Values[Quiet@CoefficientRules[Expand[basis . A . basis-poly],vars]]==0];
sol=Quiet@Solve[eqns,DeleteDuplicates[Flatten[A]]];
If[!ListQ[sol]||sol==={},Return[$Failed]];
rules=First[sol]/. C[_]->0;
A/. rules/. Thread[DeleteDuplicates[Flatten[A]]->0]];

decomposeConstraintData[cMatrix_,lambda_,verbose_:False]:=Module[{coff,bcCoff,linCoff,allVars,basisLen,matI,matC,matH,matG,matF,nBc,nLin,hasBilinear,matOmegaH,matOmegaG,matLinear,matGamma,matM,eigenValues,eigenVectors,matV,matDMinus,matM2,BMI2,matN,matNzI},coff=Variables[Flatten[cMatrix]];
linCoff=Select[coff,MultiplierVarQ];
linCoff=DeleteDuplicates[Prepend[linCoff,lambda]];
bcCoff=Select[coff,BarrierVarQ];
allVars=DeleteDuplicates[Join[bcCoff,linCoff]];
basisLen=Length[cMatrix];
matI=IdentityMatrix[basisLen];
matC=cMatrix/. Thread[allVars->0];
nBc=Length[bcCoff];nLin=Length[linCoff];
matH=If[nBc>0,Table[Coefficient[cMatrix/. Thread[DeleteCases[allVars,bcCoff[[ii]]]->0],bcCoff[[ii]]],{ii,1,nBc}],{}];
matG=If[nLin>0,Table[Coefficient[cMatrix/. Thread[DeleteCases[allVars,linCoff[[jj]]]->0],linCoff[[jj]]],{jj,1,nLin}],{}];
matOmegaH=If[nBc>0,ArrayFlatten[{matH}],ConstantArray[0,{basisLen,0}]];
matOmegaG=If[nLin>0,ArrayFlatten[{matG}],ConstantArray[0,{basisLen,0}]];
matLinear=If[allVars==={},matC,Join[matOmegaH,matOmegaG,2] . KroneckerProduct[allVars,matI]+matC];
If[nBc>0&&nLin>0,matF=Table[Coefficient[cMatrix,bcCoff[[ii]]*linCoff[[jj]]],{ii,1,nBc},{jj,1,nLin}];
hasBilinear=!AllTrue[Flatten[matF],PossibleZeroQ];,hasBilinear=False;];
If[hasBilinear,matGamma=(1/2)*ArrayFlatten[Table[matF[[ii,jj]],{ii,1,nBc},{jj,1,nLin}]];
matM=ArrayFlatten[{{ConstantArray[0,{nBc*basisLen,nBc*basisLen}],matGamma},{Transpose[matGamma],ConstantArray[0,{nLin*basisLen,nLin*basisLen}]}}];
{eigenValues,eigenVectors}=Eigensystem[Normal[matM]];
matV=If[eigenVectors==={},IdentityMatrix[Length[matM]],Normalize/@eigenVectors]/. Indeterminate->0;
matDMinus=DiagonalMatrix[Max[#,0]&/@eigenValues]-DiagonalMatrix[eigenValues];
matM2=Chop[Transpose[matV] . matDMinus . matV];
BMI2=Transpose[KroneckerProduct[allVars,matI]] . matM2 . KroneckerProduct[allVars,matI];
matN=Chop[Transpose[matV] . DiagonalMatrix[Sqrt[Max[#,0]]&/@eigenValues] . matV];
matNzI=matN . KroneckerProduct[allVars,matI];,BMI2=ConstantArray[0,{basisLen,basisLen}];
matNzI=ConstantArray[0,{0,Length[allVars]*basisLen}];];
<|"Matrix"->cMatrix,"Constant"->matC,"Linear"->matLinear,"BMI2"->BMI2,"NzI"->matNzI,"Vars"->allVars,"BasisLen"->basisLen,"HasBilinear"->hasBilinear,"Type"->If[hasBilinear,"BMI","LMI"]|>];

BuildGramConstraintData[sosState_Association,lambda_Symbol,verbose_:False]:=Catch[Module[{constraints=sosState["Constraints"],varSet=sosState["Vars"],cMatrixSet={},constraintDataSet={},n,sosConstraint,degree,basis,cMatrix},For[n=1,n<=Length[constraints],n++,sosConstraint=constraints[[n]];
degree=Ceiling[polyDegree[sosConstraint,varSet]/2];
basis=monomList[varSet,degree];
cMatrix=coefficientMatrix[varSet,basis,sosConstraint];
If[cMatrix===$Failed,Print["[Error] Gram matrix construction failed at constraint ",n];Throw[$Failed]];
cMatrix=-cMatrix+lambda*IdentityMatrix[Length[cMatrix]];
AppendTo[cMatrixSet,cMatrix];
AppendTo[constraintDataSet,decomposeConstraintData[cMatrix,lambda,verbose]];];
<|"GramMatrices"->cMatrixSet,"ConstraintData"->constraintDataSet|>]];

(* ============================================================*)
(*7. Sequential SDP Main Loop*)
(* ============================================================*)

buildLinearizedConstraint[data_Association,ptRules_]:=Module[{vars=data["Vars"],matL=data["Linear"],matBMI=data["BMI2"],taylorBMI,normRules},normRules=NormalizePointRules[ptRules];
taylorBMI=(matBMI/. normRules)+Total[Map[(#-(#/. normRules))*(D[matBMI,#]/. normRules)&,vars]];
symmetrizeMatrix[matL-taylorBMI]];

SolveBySequentialSDP[gramData_Association,lambda_Symbol,problem_Association,opts_Association:<||>]:=Module[{cMatrixSet=gramData["GramMatrices"],constraintDataSet=gramData["ConstraintData"],decisionVars,SDPVars,boundedVars,polyVars,initialRules,fixedRules,sdpConstraints,sdpResult,optimum,zeta,k=1,dist,paraRange,epsilonConv,deltaConv,lambdaStop,maxIter,verbose,sTime},sTime=AbsoluteTime[];
(*Aligned with original author's parameters*)paraRange=Lookup[problem,"paraRange",{-50,50}];
epsilonConv=Lookup[problem,"epsilonConv",10^-2];
deltaConv=Lookup[problem,"deltaConv",10^3];(*Scaled trust region*)lambdaStop=Lookup[problem,"lambdaStop",-10^-5];(*Early stopping threshold for lambda*)maxIter=Lookup[opts,"MaxIterations",200];
verbose=Lookup[opts,"Verbose",True];
decisionVars=Select[Variables[Flatten[cMatrixSet]],BarrierVarQ[#]||MultiplierVarQ[#]||#===lambda&];
SDPVars=Prepend[DeleteCases[decisionVars,lambda],lambda];
If[verbose,Print["[SDP] Total variables count: ",Length[SDPVars]]];
initialRules=NormalizePointRules[BuildSolverVariableBundle[SDPVars,lambda]];
fixedRules=FilterRules[initialRules,Except[lambda]];
If[verbose,Print["[SDP] Initial probing for lambda with heuristic point..."]];
sdpConstraints=Table[With[{mat=cMatrixSet[[ii]]/. fixedRules,d=Length[cMatrixSet[[ii]]]},VectorLessEqual[{N[mat],0},{"SemidefiniteCone",d}]],{ii,Length[cMatrixSet]}];
sdpResult=Quiet@SemidefiniteOptimization[-lambda,sdpConstraints,{lambda}];
If[!ListQ[sdpResult],Return[$Failed]];
optimum=Join[fixedRules,sdpResult];
If[verbose,Print["[SDP] Initial lambda = ",NumberForm[lambda/. optimum,{8,6}]]];
zeta=Unique["zeta"];
AppendTo[SDPVars,zeta];
optimum=Join[optimum,{zeta->0.0}];
boundedVars=DeleteCases[SDPVars,lambda];
polyVars=DeleteCases[boundedVars,zeta];(*Exact polynomial coefficients for distance norm*)If[verbose,Print["[SDP] Starting Taylor-based iterations..."]];
(*Stop loop if lambda reaches lambdaStop,or max iterations reached*)While[k<=maxIter&&(lambda/. optimum)<lambdaStop,sdpConstraints=Table[Module[{data=constraintDataSet[[i]],matNzI,dNzI,matCorner},matNzI=data["NzI"];dNzI=Length[matNzI];
matCorner=buildLinearizedConstraint[data,optimum];
If[data["HasBilinear"]&&dNzI>0,VectorLessEqual[{Join[Join[-IdentityMatrix[dNzI],matNzI,2],Join[Transpose[matNzI],matCorner,2]],0},{"SemidefiniteCone",dNzI+data["BasisLen"]}],VectorLessEqual[{matCorner,0},{"SemidefiniteCone",data["BasisLen"]}]]],{i,Length[constraintDataSet]}];
With[{diff=(polyVars)-(polyVars/. optimum)},AppendTo[sdpConstraints,VectorLessEqual[{-Join[{Prepend[diff,2 zeta/deltaConv]},Join[List/@diff,IdentityMatrix[Length[diff]],2]],0},{"SemidefiniteCone",Length[diff]+1}]];];
sdpResult=Quiet@SemidefiniteOptimization[-lambda-zeta,{sdpConstraints,boundedVars\[Element]Cuboid[Table[paraRange[[1]],Length[boundedVars]],Table[paraRange[[2]],Length[boundedVars]]]},SDPVars];
If[!ListQ[sdpResult]||!AllTrue[Values[sdpResult],NumericQ],If[verbose,Print["[Warning] Iteration ",k," failed or unbounded."]];
Break[]];
sdpResult=NormalizePointRules[sdpResult];
(*Calculate distance strictly on polynomial coefficients (excluding zeta)*)dist=Norm[(polyVars/. sdpResult)-(polyVars/. optimum)];
optimum=sdpResult;
If[verbose,Print["  [Iter ",k,"] lambda = ",NumberForm[lambda/. optimum,{8,6}],", dist = ",NumberForm[dist,{8,4}]]];
(*Check distance convergence threshold*)If[dist<=epsilonConv,If[verbose,Print["[SDP] Converged by solution distance (dist <= ",epsilonConv,")."]];
Break[]];
k++;];
If[k>maxIter,If[verbose,Print["[SDP] Maximum iterations reached."]]];
If[(lambda/. optimum)>=lambdaStop,If[verbose,Print["[SDP] Early stopping triggered: Valid barrier found."]]];
<|"Optimum"->optimum,"Iterations"->Min[k,maxIter],"FinalLambda"->(lambda/. optimum),"SDPTime"->AbsoluteTime[]-sTime|>];


(* ============================================================*)
(*8. Algebraic Verification Engine (FindInstance-based)*)
(* ============================================================*)

VerifyCertificate[spec_Association,pData_Association,B_]:=Module[{vars,bounds,BExact,toCond,eqCond,invariant,invariantNext,preCond,guardCond,negGuardCond,unsafeCond,branchCond,ce1,ce2,ce3,res,vStart,vTime},vStart=AbsoluteTime[];
vars=pData["varSet"];
bounds=And@@Map[#>=0&,Flatten[Map[{#-spec["xBound"][[1]],spec["xBound"][[2]]-#}&,vars]]];
(*Extract algebraic manifold constraints*)eqCond=If[Length[pData["eqPolys"]]==0,True,And@@Map[#==0&,pData["eqPolys"]]];
(*Float to exact fraction to prevent Numerical Error*)BExact=Rationalize[B,0];
(*The strictly defined invariant:Conjunction of manifold equalities and synthesized barrier*)invariant=eqCond&&(BExact>=0);
toCond[list_]:=If[Length[Flatten[{list}]]==0,True,And@@Map[#>=0&,Flatten[{list}]]];
preCond=toCond[pData["preListWork"]];
guardCond=toCond[pData["guardListWork"]];
unsafeCond=toCond[pData["negPostListWork"]];
(*Determine negation of guard condition*)negGuardCond=If[Length[Flatten[{pData["guardListWork"]}]]==0,True,Or@@Map[#<0&,Flatten[{pData["guardListWork"]}]]];
Print["\n==========================================="];
Print["[Verification] Starting Algebraic Verification"];
Print["==========================================="];
(*CE1:Init Check (pre=>invariant)*)ce1=FindInstance[Not[Implies[bounds&&preCond,invariant]],vars,Reals];
Print["[Check 1: Init] pre => invariant"];
If[ce1==={},Print["  -> [PASS]"],Print["  -> [FAIL] Counterexample: ",ce1]];
(*CE2:Inductive Check (invariant&&guard&&branchCond=>invariantNext)*)ce2=Table[invariantNext=invariant/. Thread[vars->pData["branchPxList"][[i]]];
branchCond=toCond[pData["branchCondListWork"][[i]]];
res=FindInstance[Not[Implies[bounds&&invariant&&guardCond&&branchCond,invariantNext]],vars,Reals];
Print["[Check 2: Branch ",i,"] invariant && guard && cond => invariant(next)"];
If[res==={},Print["  -> [PASS]"],Print["  -> [FAIL] Counterexample: ",res]];
res,{i,1,Length[pData["branchPxList"]]}];
ce2=Flatten[ce2,1];
(*CE3:Exit Check (invariant&&!guard=>safe)*)ce3=FindInstance[bounds&&invariant&&negGuardCond&&unsafeCond,vars,Reals];
Print["[Check 3: Exit] invariant && !guard => post"];
If[ce3==={},Print["  -> [PASS]"],Print["  -> [FAIL] Counterexample: ",ce3]];
vTime=AbsoluteTime[]-vStart;
If[Length[Flatten[Join[ce1,ce2,ce3]]]==0,Print["\n[Result] Verified successfully. (Validation Time: ",NumberForm[vTime,{8,3}]," s)"];
<|"Verified"->True,"ValidationTime"->vTime|>,Print["\n[Result] Numerical Error Detected or Invalid Barrier. (Validation Time: ",NumberForm[vTime,{8,3}]," s)"];
<|"Verified"->False,"ValidationTime"->vTime|>]];

(* ============================================================*)
(*9. Main Controller Interface*)
(* ============================================================*)

MainMultiRefactored[spec_Association,wideg_Integer:2,epsilon_Real:0.01,opts_Association:<||>]:=Module[{pData,sosState,lam,gramData,problemConfig,result,finalInv,verbose,verifyRes,totalTime,tStart},tStart=AbsoluteTime[];
verbose=Lookup[opts,"Verbose",False];
If[verbose,Print["\n[Main] Step 1: Preprocessing..."]];
pData=PreprocessProblem[spec];
If[pData===$Failed,Return[$Failed]];
If[verbose,Print["[Main] Step 2: Initializing SOS state..."]];
sosState=InitSosState[pData["varSet"],pData["invWork"]];
If[verbose,Print["[Main] Step 3: Adding constraints..."]];
sosState=AddInitializationConstraints[pData,sosState,wideg];
sosState=AddExitConstraints[pData,sosState,epsilon,wideg];
sosState=AddBranchInductivenessConstraints[pData,sosState,epsilon,wideg];
If[verbose,Print["[Main] Step 4: Building Gram matrices..."]];
lam=Unique["lam$"];
gramData=BuildGramConstraintData[sosState,lam,verbose];
If[verbose,Print["\n[Main] Step 5: Sequential SDP Solving..."]];
(*\:4f20\:5165\:539f\:4f5c\:8005\:8bbe\:5b9a\:7684\:7ecf\:5178\:8d85\:53c2\:6570*)problemConfig=<|"paraRange"->{-50,50},"epsilonConv"->10^-2,"deltaConv"->10^3,"lambdaStop"->-10^-5|>;
result=SolveBySequentialSDP[gramData,lam,problemConfig,opts];
If[result===$Failed||(lam/. result["Optimum"])<problemConfig["lambdaStop"],If[verbose,Print["\n[Main] [FAIL] Failed to synthesize barrier."]];
Return[<|"Status"->"Failed","Result"->result|>]];
If[verbose,Print["[Main] SDP Solving completed in ",NumberForm[result["SDPTime"],{8,3}]," seconds."]];
finalInv=Chop[Expand[spec["inv"]/. result["Optimum"]],10^-4];
If[verbose,Print["\n[Main] Barrier candidate synthesized. Proceeding to Algebraic Verification..."]];
verifyRes=VerifyCertificate[spec,pData,finalInv];
totalTime=AbsoluteTime[]-tStart;
<|"Status"->If[verifyRes["Verified"],"Verified","NumericalError"],"BarrierCertificate"->finalInv,"Lambda"->(lam/. result["Optimum"]),"Iterations"->result["Iterations"],"SDPTime"->result["SDPTime"],"ValidationTime"->verifyRes["ValidationTime"],"TotalTime"->totalTime|>];

End[];
EndPackage[];
