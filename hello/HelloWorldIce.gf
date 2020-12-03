concrete HelloWorldIce of HelloWorld = open ResIce in {
  lincat
    Greeting = Str ;
    Recipient = Rec ;

  lin
    Hello rec = hello ! rec.a ++ rec.s ;

    World    = mkRec "heimur" Sg Masc ;
    Darling  = mkRec "elska"  Sg Fem ;
    Sisters  = mkRec "systur" Pl Fem ;
    Brothers = mkRec "bræður" Pl Masc ;
}
