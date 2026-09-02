(set-logic ALL)

( declare-const x1 Real )
( declare-const x1! Real )
( declare-const x2 Real )
( declare-const x2! Real )

( declare-const x1_0 Real )
( declare-const x1_1 Real )
( declare-const x1_2 Real )
( declare-const x2_0 Real )
( declare-const x2_1 Real )
( declare-const x2_2 Real )

( define-fun inv-f( ( x1 Real )( x2 Real ) ) Bool
SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
)

( define-fun pre-f ( ( x1 Real )( x2 Real )( x1_0 Real )( x1_1 Real )( x1_2 Real )( x2_0 Real )( x2_1 Real )( x2_2 Real ) ) Bool
	( and
		( = x1 x1_0 )
		( = x2 x2_0 )
		( >= x1_0 -50 )
		( <= x1_0 50 )
		( >= x2_0 -50 )
		( <= x2_0 50 )
		( >= ( - ( + -0.350000 ( * 1.200000 x1_0 ) ) ( * x1_0 x1_0 ) ) 0 )
		( >= ( - ( + -0.350000 ( * 1.200000 x2_0 ) ) ( * x2_0 x2_0 ) ) 0 )
	)
)

( define-fun trans-f ( ( x1 Real )( x2 Real )( x1! Real )( x2! Real )( x1_0 Real )( x1_1 Real )( x1_2 Real )( x2_0 Real )( x2_1 Real )( x2_2 Real ) ) Bool
	( or
		( and
			( = x1_1 x1 )
			( = x2_1 x2 )
			( = x1_1 x1! )
			( = x2_1 x2! )
		)
		( and
			( = x1_1 x1 )
			( = x2_1 x2 )
			( >= ( - ( - 1 ( * x1_1 x1_1 ) ) ( * x2_1 x2_1 ) ) 0 )
			( = x1_2 ( + ( * ( * ( * 0.500000 x1_1 ) x1_1 ) x1_1 ) ( * ( * 0.400000 x2_1 ) x2_1 ) ) )
			( = x2_2 ( + ( * ( * -0.600000 x1_2 ) x1_2 ) ( * ( * 0.300000 x2_1 ) x2_1 ) ) )
			( = x1_2 x1! )
			( = x2_2 x2! )
		)
	)
)

( define-fun post-f ( ( x1 Real )( x2 Real )( x1_0 Real )( x1_1 Real )( x1_2 Real )( x2_0 Real )( x2_1 Real )( x2_2 Real ) ) Bool
	( or
		( not
			( and
				( = x1 x1_1)
				( = x2 x2_1)
			)
		)
		( not
			( and
				( not ( >= ( - ( - 1 ( * x1_1 x1_1 ) ) ( * x2_1 x2_1 ) ) 0 ) )
				( not ( <= ( - ( + ( * x1_1 x1_1 ) ( * x2_1 x2_1 ) ) 0.360000 ) 0 ) )
			)
		)
	)
)
SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
( assert ( not
	( =>
		( pre-f x1 x2 x1_0 x1_1 x1_2 x2_0 x2_1 x2_2  )
		( inv-f x1 x2 )
	)
))

SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
( assert ( not
	( =>
		( and
			( inv-f x1 x2 )
			( trans-f x1 x2 x1! x2! x1_0 x1_1 x1_2 x2_0 x2_1 x2_2 )
		)
		( inv-f x1! x2! )
	)
))

SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
( assert ( not
	( =>
		( inv-f x1 x2  )
		( post-f x1 x2 x1_0 x1_1 x1_2 x2_0 x2_1 x2_2 )
	)
))

