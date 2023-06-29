ScheduleCasePriorityUpdate scpu = new ScheduleCasePriorityUpdate();
String sch = '0 55 * * * ?';
System.schedule('Schedule Case Priority Update 55', sch, scpu);