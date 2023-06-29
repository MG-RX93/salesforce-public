ScheduleCasePriorityUpdate scpu = new ScheduleCasePriorityUpdate();
String sch = '0 10 * * * ?';
System.schedule('Schedule Case Priority Update', sch, scpu);