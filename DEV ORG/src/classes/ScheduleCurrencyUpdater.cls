global class ScheduleCurrencyUpdater implements Schedulable {
   
   global void execute(SchedulableContext ctx) {
     CurrencyConvRateUpdater.updatecurr(); 
   }   
}