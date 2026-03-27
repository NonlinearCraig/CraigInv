
# Artifact Evaluation: Baseline Reproduction Guide

This repository contains the benchmark suite, execution scripts, and necessary environments to reproduce the baseline results presented in our paper. The baselines include **CraigInv**, **NoCraig**, **Prajna**, **CraigPrajna**, **BCDC**, **PolySynth**, and **LaM4Inv**.

---

## 🛠️ Prerequisites

Before running the experiments, please ensure the following software dependencies are installed and configured on your system:

* **MATLAB** (Required for CraigInv, NoCraig, Prajna, and CraigPrajna)
* **Wolfram Mathematica** (Required for BCDC)
* **Python / C++ Build Tools** (Required for external baselines PolySynth and LaM4Inv)

---

## 🚀 Reproducing Baseline Results

### 1. MATLAB-based Baselines
**(CraigInv, NoCraig, Prajna, and CraigPrajna)**

These tools are integrated into a unified MATLAB evaluation framework.

**Execution Steps:**

1. Launch MATLAB and open this repository's directory.
2. Add the baseline folder to your MATLAB path. 

3. Run the main execution script to generate the invariants:
   
       run_all

4. **Post-Verification:** Once the invariants are generated, execute the verification script to validate the results:
   
       verify


### 2. Mathematica-based Baseline
**(BCDC)**

**Execution Steps:**

1. Open Wolfram Mathematica.
2. Navigate to the BCDC directory and open the notebook file: `BCDC.nb`.
3. Click **Evaluation** -> **Evaluate Notebook** (or simply click **Run**) to execute all cells and obtain the benchmark results.


### 3. External Baselines
**(PolySynth and LaM4Inv)**

For these state-of-the-art tools, we utilize their official implementations alongside our standardized benchmark suite.

* **PolySynth:**
  * Please download and install the official tool from the [PolySynth GitHub Repository](https://github.com/hitarths/polysynth).
  * We have provided a dedicated set of formatted benchmarks and specific execution instructions. Please refer to the detailed guide in our [`polysynth_benchmark/README.md`](./path_to_your_polysynth_readme.md) directory to prepare the environment and run these tests.

* **LaM4Inv:**
  * Access the official repository at the [SoftWiser-group/LaM4Inv GitHub](https://github.com/SoftWiser-group/LaM4Inv) to download and configure the package.
  * Once the environment is set up, directly feed our provided benchmark suite into their pipeline to reproduce the baseline comparison.

---

## 📊 Expected Output

*The execution scripts will output the invariant generation time and verification status for each benchmark. Please refer to the paper for the detailed baseline comparison data.*


