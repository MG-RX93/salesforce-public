ScheduleCaseUpdates scu = new ScheduleCaseUpdates();
String sch = '0 30 * * * ?';
System.schedule('Schedule Case Updates 30', sch, scu);