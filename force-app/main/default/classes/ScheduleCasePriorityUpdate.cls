global class ScheduleCasePriorityUpdate implements Schedulable {
	global void execute(SchedulableContext sc) {
		this.updateCasePriority();
	}

	private void updateCasePriority() {
		List<Case> caseUpdateList = new List<Case>();
		List<Case> caseList = [SELECT Id, Priority FROM Case];
		for (Case c : caseList) {
			switch on c.Priority {
				when 'Low' {
					c.Priority = 'High';
				}
				when 'Medium' {
					c.Priority = 'Low';
				}
				when 'High' {
					c.Priority = 'Medium';
				}
				when null {
					c.Priority = 'High';
				}
			}
			caseUpdateList.add(c);
		}
		update caseUpdateList;
	}

}