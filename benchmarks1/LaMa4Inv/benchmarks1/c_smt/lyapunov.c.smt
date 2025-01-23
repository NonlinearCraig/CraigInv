(set-logic ALL)

( declare-const x1 Real )
( declare-const x1! Real )
( declare-const x2 Real )
( declare-const x2! Real )
( declare-const x3 Real )
( declare-const x3! Real )

( declare-const x1_0 Real )
( declare-const x1_1 Real )
( declare-const x1_2 Real )
( declare-const x2_0 Real )
( declare-const x2_1 Real )
( declare-const x2_2 Real )
( declare-const x3_0 Real )
( declare-const x3_1 Real )
( declare-const x3_2 Real )

( define-fun inv-f( ( x1 Real )( x2 Real )( x3 Real ) ) Bool
SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
)

( define-fun pre-f ( ( x1 Real )( x2 Real )( x3 Real )( x1_0 Real )( x1_1 Real )( x1_2 Real )( x2_0 Real )( x2_1 Real )( x2_2 Real )( x3_0 Real )( x3_1 Real )( x3_2 Real ) ) Bool
	( and
		( = x1 x1_0 )
		( = x2 x2_0 )
		( = x3 x3_0 )
		( >= x1_0 -5 )
		( <= x1_0 5 )
		( >= x2_0 -5 )
		( <= x2_0 5 )
		( >= x3_0 -5 )
		( <= x3_0 5 )
		( <= ( - ( + ( + ( * x1_0 x1_0 ) ( * x2_0 x2_0 ) ) ( * x3_0 x3_0 ) ) 0.250000 ) 0 )
	)
)

( define-fun trans-f ( ( x1 Real )( x2 Real )( x3 Real )( x1! Real )( x2! Real )( x3! Real )( x1_0 Real )( x1_1 Real )( x1_2 Real )( x2_0 Real )( x2_1 Real )( x2_2 Real )( x3_0 Real )( x3_1 Real )( x3_2 Real ) ) Bool
	( or
		( and
			( = x1_1 x1 )
			( = x2_1 x2 )
			( = x3_1 x3 )
			( = x1_1 x1! )
			( = x2_1 x2! )
			( = x3_1 x3! )
		)
		( and
			( = x1_1 x1 )
			( = x2_1 x2 )
			( = x3_1 x3 )
			( >= ( - ( - ( - 9 ( * x1_1 x1_1 ) ) ( * x2_1 x2_1 ) ) ( * x3_1 x3_1 ) ) 0 )
			( = x1_2 ( - x1_1 ( * 0.100000 x2_1 ) ) )
			( = x2_2 ( - x2_1 ( * 0.100000 x3_1 ) ) )
			( = x3_2 ( + ( - ( + ( * -0.100000 x1_2 ) ( * ( * ( * 0.100000 x1_2 ) x1_2 ) x1_2 ) ) ( * 0.200000 x2_2 ) ) ( * 0.900000 x3_1 ) ) )
			( = x1_2 x1! )
			( = x2_2 x2! )
			( = x3_2 x3! )
		)
	)
)

( define-fun post-f ( ( x1 Real )( x2 Real )( x3 Real )( x1_0 Real )( x1_1 Real )( x1_2 Real )( x2_0 Real )( x2_1 Real )( x2_2 Real )( x3_0 Real )( x3_1 Real )( x3_2 Real ) ) Bool
	( or
		( not
			( and
				( = x1 x1_1)
				( = x2 x2_1)
				( = x3 x3_1)
			)
		)
		( not
			( and
				( not ( >= ( - ( - ( - 9 ( * x1_1 x1_1 ) ) ( * x2_1 x2_1 ) ) ( * x3_1 x3_1 ) ) 0 ) )
				( not ( <= ( + ( + ( + ( - ( - ( - ( - ( - ( * -2 x1_1 ) ( * 2 x2_1 ) ) ( * 2 x3_1 ) ) ( * x1_1 x1_1 ) ) ( * x2_1 x2_1 ) ) ( * x3_1 x3_1 ) ) ( * x1_1 x2_1 ) ) ( * x1_1 x3_1 ) ) ( * x2_1 x3_1 ) ) 0 ) )
			)
		)
	)
)
SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
( assert ( not
	( =>
		( pre-f x1 x2 x3 x1_0 x1_1 x1_2 x2_0 x2_1 x2_2 x3_0 x3_1 x3_2  )
		( inv-f x1 x2 x3 )
	)
))

SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
( assert ( not
	( =>
		( and
			( inv-f x1 x2 x3 )
			( trans-f x1 x2 x3 x1! x2! x3! x1_0 x1_1 x1_2 x2_0 x2_1 x2_2 x3_0 x3_1 x3_2 )
		)
		( inv-f x1! x2! x3! )
	)
))

SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
( assert ( not
	( =>
		( inv-f x1 x2 x3  )
		( post-f x1 x2 x3 x1_0 x1_1 x1_2 x2_0 x2_1 x2_2 x3_0 x3_1 x3_2 )
	)
))

