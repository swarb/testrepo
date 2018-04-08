public class sep3controller{
public List<Account> a{get;set;}
public sep3controller()
{a=[select Id,Name from Account];
}
}