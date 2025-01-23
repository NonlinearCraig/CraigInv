(set-logic ALL)

( declare-const a Real )
( declare-const a! Real )
( declare-const e Real )
( declare-const e! Real )
( declare-const p Real )
( declare-const p! Real )
( declare-const q Real )
( declare-const q! Real )
( declare-const r Real )
( declare-const r! Real )

( declare-const a_0 Real )
( declare-const e_0 Real )
( declare-const p_0 Real )
( declare-const p_1 Real )
( declare-const p_2 Real )
( declare-const p_3 Real )
( declare-const p_4 Real )
( declare-const q_0 Real )
( declare-const q_1 Real )
( declare-const q_2 Real )
( declare-const q_3 Real )
( declare-const r_0 Real )
( declare-const r_1 Real )
( declare-const r_2 Real )
( declare-const r_3 Real )
( declare-const r_4 Real )

( define-fun inv-f( ( a Real )( e Real )( p Real )( q Real )( r Real ) ) Bool
SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
)

( define-fun pre-f ( ( a Real )( e Real )( p Real )( q Real )( r Real )( a_0 Real )( e_0 Real )( p_0 Real )( p_1 Real )( p_2 Real )( p_3 Real )( p_4 Real )( q_0 Real )( q_1 Real )( q_2 Real )( q_3 Real )( r_0 Real )( r_1 Real )( r_2 Real )( r_3 Real )( r_4 Real ) ) Bool
	( and
		( = a a_0 )
		( = e e_0 )
		( = p p_0 )
		( = q q_0 )
		( = r r_0 )
		( = r_0 ( - a_0 1 ) )
		( = q_0 1 )
		( = p_0 0.500000 )
		( >= e_0 0 )
		( >= a_0 1 )
	)
)

( define-fun trans-f ( ( a Real )( e Real )( p Real )( q Real )( r Real )( a! Real )( e! Real )( p! Real )( q! Real )( r! Real )( a_0 Real )( e_0 Real )( p_0 Real )( p_1 Real )( p_2 Real )( p_3 Real )( p_4 Real )( q_0 Real )( q_1 Real )( q_2 Real )( q_3 Real )( r_0 Real )( r_1 Real )( r_2 Real )( r_3 Real )( r_4 Real ) ) Bool
	( or
		( and
			( = p_1 p )
			( = q_1 q )
			( = r_1 r )
			( = p_1 p! )
			( = q_1 q! )
			( = r_1 r! )
			( = e e_0 )
			( = e! e_0 )
			( = a a! )
			( = q q! )
		)
		( and
			( = p_1 p )
			( = q_1 q )
			( = r_1 r )
			( <= e_0 ( * ( * 2 p_1 ) r_1 ) )
			( <= ( + p_1 ( * 2 q_1 ) ) ( * 2 r_1 ) )
			( = r_2 ( - ( - ( * 2 r_1 ) ( * 2 q_1 ) ) p_1 ) )
			( = q_2 ( + q_1 p_1 ) )
			( = p_2 ( / p_1 2 ) )
			( = p_3 p_2 )
			( = q_3 q_2 )
			( = r_3 r_2 )
			( = p_3 p! )
			( = q_3 q! )
			( = r_3 r! )
			(= a a_0 )
			(= a! a_0 )
			(= e e_0 )
			(= e! e_0 )
		)
		( and
			( = p_1 p )
			( = q_1 q )
			( = r_1 r )
			( <= e_0 ( * ( * 2 p_1 ) r_1 ) )
			( not ( <= ( + p_1 ( * 2 q_1 ) ) ( * 2 r_1 ) ) )
			( = r_4 ( * 2 r_1 ) )
			( = p_4 ( / p_1 2 ) )
			( = p_3 p_4 )
			( = q_3 q_1 )
			( = r_3 r_4 )
			( = p_3 p! )
			( = q_3 q! )
			( = r_3 r! )
			(= a a_0 )
			(= a! a_0 )
			(= e e_0 )
			(= e! e_0 )
		)
	)
)

( define-fun post-f ( ( a Real )( e Real )( p Real )( q Real )( r Real )( a_0 Real )( e_0 Real )( p_0 Real )( p_1 Real )( p_2 Real )( p_3 Real )( p_4 Real )( q_0 Real )( q_1 Real )( q_2 Real )( q_3 Real )( r_0 Real )( r_1 Real )( r_2 Real )( r_3 Real )( r_4 Real ) ) Bool
	( or
		( not
			( and
				( = a a_0)
				( = e e_0)
				( = p p_1)
				( = q q_1)
				( = r r_1)
			)
		)
		( not
			( and
				( not ( <= e_0 ( * ( * 2 p_1 ) r_1 ) ) )
				( not ( <= ( - a_0 e_0 ) ( * q_1 q_1 ) ) )
			)
		)
	)
)
SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
( assert ( not
	( =>
		( pre-f a e p q r a_0 e_0 p_0 p_1 p_2 p_3 p_4 q_0 q_1 q_2 q_3 r_0 r_1 r_2 r_3 r_4  )
		( inv-f a e p q r )
	)
))

SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
( assert ( not
	( =>
		( and
			( inv-f a e p q r )
			( trans-f a e p q r a! e! p! q! r! a_0 e_0 p_0 p_1 p_2 p_3 p_4 q_0 q_1 q_2 q_3 r_0 r_1 r_2 r_3 r_4 )
		)
		( inv-f a! e! p! q! r! )
	)
))

SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
( assert ( not
	( =>
		( inv-f a e p q r  )
		( post-f a e p q r a_0 e_0 p_0 p_1 p_2 p_3 p_4 q_0 q_1 q_2 q_3 r_0 r_1 r_2 r_3 r_4 )
	)
))

