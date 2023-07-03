ScheduleCaseUpdates scu = new ScheduleCaseUpdates();
String sch = '0 15 * * * ?';
System.schedule('Schedule Case Updates 15', sch, scu);