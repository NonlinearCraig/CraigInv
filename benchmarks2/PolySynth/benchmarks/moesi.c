real modified, shared, exclusive, invalid, owned, total;
@pre((invalid >= 1 and owned >= 1));
exclusive = 0;
modified = 0;
shared = 0;

while (1>=0, 
    (
        ((modified>= 0 and shared >= 0) and ((exclusive >=0 and invalid >= 0) and owned >= 0))
        and
        ([(modified, shared, exclusive, owned, invalid),1]>=0)
    )
    ) {
    
    ndif
  {

    [assume(invalid >= 1)]{
      shared = ((shared + exclusive) + 1);
      owned = (owned + modified);
      invalid = (invalid - 1);
      exclusive = 0;    
      modified = 0;
    }

    [assume(exclusive >= 1)]{

      exclusive = (exclusive - 1);
      modified = (modified + 1);
    }

    [assume(shared >= 1)] {
      invalid = ((modified + shared) + ((exclusive + invalid) + (owned - 1)));
      shared = 0;
      exclusive = 1;
      modified = 0;
      owned = 0;
    }
    [assume(owned >= 1)] {
      invalid =  ((modified + shared) + ((exclusive + invalid) + (owned - 1)));
      shared = 0;
      exclusive = 1;
      modified = 0;
      owned = 0;
    }

    [assume(invalid >= 1)] {
      invalid = ((modified + shared) + ((exclusive + invalid) + (owned - 1)));
      shared = 0;
      exclusive = 1;
      modified = 0;
      owned = 0;
    }

  }
}
@post(1>=0);