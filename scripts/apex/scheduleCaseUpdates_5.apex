ScheduleCaseUpdates scu = new ScheduleCaseUpdates();
String sch = '0 5 * * * ?';
System.schedule('Schedule Case Updates', sch, scu);