(set-logic LIA)

( declare-const x1 Int )
( declare-const x1! Int )
( declare-const x2 Int )
( declare-const x2! Int )
( declare-const tmp Int )
( declare-const tmp! Int )

( declare-const x1_0 Int )
( declare-const x1_1 Int )
( declare-const x1_2 Int )
( declare-const x2_0 Int )
( declare-const x2_1 Int )
( declare-const x2_2 Int )

( define-fun inv-f( ( x1 Int )( x2 Int )( tmp Int ) ) Bool
SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
)

( define-fun pre-f ( ( x1 Int )( x2 Int )( tmp Int )( x1_0 Int )( x1_1 Int )( x1_2 Int )( x2_0 Int )( x2_1 Int )( x2_2 Int ) ) Bool
	( and
		( = x1 x1_0 )
		( = x2 x2_0 )
		( >= x1_0 -50 )
		( <= x1_0 50 )
		( >= x2_0 -50 )
		( <= x2_0 50 )
		( >= ( - ( + ( - ( + 0.125000 x1_0 ) ( * x1_0 x1_0 ) ) x2_0 ) ( * x2_0 x2_0 ) ) 0 )
	)
)

( define-fun trans-f ( ( x1 Int )( x2 Int )( tmp Int )( x1! Int )( x2! Int )( tmp! Int )( x1_0 Int )( x1_1 Int )( x1_2 Int )( x2_0 Int )( x2_1 Int )( x2_2 Int ) ) Bool
	( or
		( and
			( = x1_1 x1 )
			( = x2_1 x2 )
			( = x1_1 x1! )
			( = x2_1 x2! )
			( = x1 x1! )
			( = x2 x2! )
			(= tmp tmp! )
		)
		( and
			( = x1_1 x1 )
			( = x2_1 x2 )
			( = x1_2 ( - ( * ( / 8 9 ) x1_1 ) ( * ( / 1 18 ) x2_1 ) ) )
			( = x2_2 ( + ( * 0.100000 x1_2 ) ( * 0.900000 x2_1 ) ) )
			( = x1_2 x1! )
			( = x2_2 x2! )
			(= tmp tmp! )
		)
	)
)

( define-fun post-f ( ( x1 Int )( x2 Int )( tmp Int )( x1_0 Int )( x1_1 Int )( x1_2 Int )( x2_0 Int )( x2_1 Int )( x2_2 Int ) ) Bool
	( or
		( not
			( and
				( = x1 x1_1)
				( = x2 x2_1)
			)
		)
		( not
			( and
				( not ( <= ( - ( * x2_1 x2_1 ) 4 ) 0 ) )
			)
		)
	)
)
SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
( assert ( not
	( =>
		( pre-f x1 x2 tmp x1_0 x1_1 x1_2 x2_0 x2_1 x2_2  )
		( inv-f x1 x2 tmp )
	)
))

SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
( assert ( not
	( =>
		( and
			( inv-f x1 x2 tmp )
			( trans-f x1 x2 tmp x1! x2! tmp! x1_0 x1_1 x1_2 x2_0 x2_1 x2_2 )
		)
		( inv-f x1! x2! tmp! )
	)
))

SPLIT_HERE_asdfghjklzxcvbnmqwertyuiop
( assert ( not
	( =>
		( inv-f x1 x2 tmp  )
		( post-f x1 x2 tmp x1_0 x1_1 x1_2 x2_0 x2_1 x2_2 )
	)
))

