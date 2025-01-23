(set-logic ALL)

( declare-const x1 Real )
( declare-const x1! Real )

( declare-const x1_0 Real )
( declare-const x1_1 Real )
( declare-const x1_2 Real )

( define-fun inv-f( ( x1 Real ) ) Bool
SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
)

( define-fun pre-f ( ( x1 Real )( x1_0 Real )( x1_1 Real )( x1_2 Real ) ) Bool
	( and
		( = x1 x1_0 )
		( >= ( - ( + 3 ( * 2 x1_0 ) ) ( * x1_0 x1_0 ) ) 0 )
	)
)

( define-fun trans-f ( ( x1 Real )( x1! Real )( x1_0 Real )( x1_1 Real )( x1_2 Real ) ) Bool
	( or
		( and
			( = x1_1 x1 )
			( = x1_1 x1! )
		)
		( and
			( = x1_1 x1 )
			( >= ( - ( + 7 ( * 1.500000 x1_1 ) ) ( * x1_1 x1_1 ) ) 0 )
			( = x1_2 ( - ( + ( * 0.992000 x1_1 ) ( * ( * 0.006000 x1_1 ) x1_1 ) ) ( * ( * ( * 0.001000 x1_1 ) x1_1 ) x1_1 ) ) )
			( = x1_2 x1! )
		)
	)
)

( define-fun post-f ( ( x1 Real )( x1_0 Real )( x1_1 Real )( x1_2 Real ) ) Bool
	( or
		( not
			( = x1 x1_1)
		)
		( not
			( and
				( not ( >= ( - ( + 7 ( * 1.500000 x1_1 ) ) ( * x1_1 x1_1 ) ) 0 ) )
				( not ( >= ( + ( - 10 ( * 7 x1_1 ) ) ( * x1_1 x1_1 ) ) 0 ) )
			)
		)
	)
)
SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
( assert ( not
	( =>
		( pre-f x1 x1_0 x1_1 x1_2  )
		( inv-f x1 )
	)
))

SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
( assert ( not
	( =>
		( and
			( inv-f x1 )
			( trans-f x1 x1! x1_0 x1_1 x1_2 )
		)
		( inv-f x1! )
	)
))

SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
( assert ( not
	( =>
		( inv-f x1  )
		( post-f x1 x1_0 x1_1 x1_2 )
	)
))

