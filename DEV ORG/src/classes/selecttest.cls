public class selecttest{
private string[] swar=new string[]{};
public String selectedCountry
{
   get
    {
       if(selectedCountry==null)
           selectedCountry='CANADA';
           return selectedCountry;
    }
set;
}
public List<SelectOption> getItems() {
                List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('MEXICO','Mexico'));
                options.add(new SelectOption('CANADA','Canada'));
                options.add(new SelectOption('CANADA','Canada'));
                options.add(new SelectOption('MEXICO','Mexico'));
                 options.add(new SelectOption('CANADA','Canada'));
                return options;
        }
        }