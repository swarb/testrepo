public with sharing class testing {
public String a{set;get;}
public String b{set;get;}
//public pagereference pg=new pagereference('');
public testing()
{a='';
b='';

}
public PageReference func()
{a=a+' '+b;
//return ApexPages.currentPage();
return null;
}
public String getparm(){
System.debug('parameter value '+apexpages.currentpage().getparameters().get('par'));
return apexpages.currentpage().getparameters().get('par');
}
}