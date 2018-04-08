public class fornothing{
public fornothing()
{
    extendme ex=new extendedclasscontroller();
    extendedclasscontroller e=(extendedclasscontroller)ex;
    Integer i,j;
    i=(j=10);
    System.debug('i-->'+i);
    j=e.i;
    e.i=20;
}
}