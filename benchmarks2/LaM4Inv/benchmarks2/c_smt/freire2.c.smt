(set-logic ALL)

( declare-const a Real )
( declare-const a! Real )
( declare-const r Real )
( declare-const r! Real )
( declare-const s Real )
( declare-const s! Real )
( declare-const x Real )
( declare-const x! Real )

( declare-const a_0 Real )
( declare-const r_0 Real )
( declare-const r_1 Real )
( declare-const r_2 Real )
( declare-const s_0 Real )
( declare-const s_1 Real )
( declare-const s_2 Real )
( declare-const x_0 Real )
( declare-const x_1 Real )
( declare-const x_2 Real )

( define-fun inv-f( ( a Real )( r Real )( s Real )( x Real ) ) Bool
SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
)

( define-fun pre-f ( ( a Real )( r Real )( s Real )( x Real )( a_0 Real )( r_0 Real )( r_1 Real )( r_2 Real )( s_0 Real )( s_1 Real )( s_2 Real )( x_0 Real )( x_1 Real )( x_2 Real ) ) Bool
	( and
		( = a a_0 )
		( = r r_0 )
		( = s s_0 )
		( = x x_0 )
		( = x_0 a_0 )
		( = r_0 1 )
		( = s_0 3.250000 )
		( >= a_0 1 )
	)
)

( define-fun trans-f ( ( a Real )( r Real )( s Real )( x Real )( a! Real )( r! Real )( s! Real )( x! Real )( a_0 Real )( r_0 Real )( r_1 Real )( r_2 Real )( s_0 Real )( s_1 Real )( s_2 Real )( x_0 Real )( x_1 Real )( x_2 Real ) ) Bool
	( or
		( and
			( = r_1 r )
			( = s_1 s )
			( = x_1 x )
			( = r_1 r! )
			( = s_1 s! )
			( = x_1 x! )
			( = a a! )
			( = r r! )
		)
		( and
			( = r_1 r )
			( = s_1 s )
			( = x_1 x )
			( <= s_1 ( - x_1 1 ) )
			( = x_2 ( - x_1 s_1 ) )
			( = r_2 ( + r_1 1 ) )
			( = s_2 ( + ( + s_1 ( * 6 r_2 ) ) 3 ) )
			( = r_2 r! )
			( = s_2 s! )
			( = x_2 x! )
			(= a a_0 )
			(= a! a_0 )
		)
	)
)

( define-fun post-f ( ( a Real )( r Real )( s Real )( x Real )( a_0 Real )( r_0 Real )( r_1 Real )( r_2 Real )( s_0 Real )( s_1 Real )( s_2 Real )( x_0 Real )( x_1 Real )( x_2 Real ) ) Bool
	( and
		( or
			( not
				( and
					( = a a_0)
					( = r r_1)
					( = s s_1)
					( = x x_1)
				)
			)
			( not
				( and
					( not ( <= s_1 ( - x_1 1 ) ) )
					( <= ( - ( - ( - ( * 4 a_0 ) ( * ( * ( * 4 r_1 ) r_1 ) r_1 ) ) ( * ( * 6 r_1 ) r_1 ) ) ( * 3 r_1 ) ) 0 )
					( not ( and ( <= ( - ( - ( - ( * 4 a_0 ) ( * ( * ( * 4 r_1 ) r_1 ) r_1 ) ) ( * ( * 6 r_1 ) r_1 ) ) ( * 3 r_1 ) ) 0 ) ( <= ( - ( - ( + ( - ( * ( * ( * 4 r_1 ) r_1 ) r_1 ) ( * ( * 6 r_1 ) r_1 ) ) ( * 3 r_1 ) ) 1 ) ( * 4 a_0 ) ) 0 ) ) )
				)
			)
		)
		( or
			( not
				( and
					( = a a_0)
					( = r r_1)
					( = s s_1)
					( = x x_1)
				)
			)
			( not
				( and
					( not ( <= s_1 ( - x_1 1 ) ) )
					( not ( <= ( - ( - ( - ( * 4 a_0 ) ( * ( * ( * 4 r_1 ) r_1 ) r_1 ) ) ( * ( * 6 r_1 ) r_1 ) ) ( * 3 r_1 ) ) 0 ) )
					( not ( and ( <= ( - ( - ( - ( * 4 a_0 ) ( * ( * ( * 4 r_1 ) r_1 ) r_1 ) ) ( * ( * 6 r_1 ) r_1 ) ) ( * 3 r_1 ) ) 0 ) ( <= ( - ( - ( + ( - ( * ( * ( * 4 r_1 ) r_1 ) r_1 ) ( * ( * 6 r_1 ) r_1 ) ) ( * 3 r_1 ) ) 1 ) ( * 4 a_0 ) ) 0 ) ) )
				)
			)
		)
	)
)
SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
( assert ( not
	( =>
		( pre-f a r s x a_0 r_0 r_1 r_2 s_0 s_1 s_2 x_0 x_1 x_2  )
		( inv-f a r s x )
	)
))

SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
( assert ( not
	( =>
		( and
			( inv-f a r s x )
			( trans-f a r s x a! r! s! x! a_0 r_0 r_1 r_2 s_0 s_1 s_2 x_0 x_1 x_2 )
		)
		( inv-f a! r! s! x! )
	)
))

SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
( assert ( not
	( =>
		( inv-f a r s x  )
		( post-f a r s x a_0 r_0 r_1 r_2 s_0 s_1 s_2 x_0 x_1 x_2 )
	)
))

