/*
 * 2 functions to concat results originating from either saved tables or the results window in Fiji.
 * Also, the runtime function.
 * 
 * author: José Serrado Marques
 * date: 19/08/2022
 * 
 */


// functions
function concatTables(all_results_table, single_table) {
	// an attempet at a modular creation of table concatenation
	
	// get current big table size
	last_table_size = Table.size(all_results_table);
	
	// get headings from Resuts table
	headings = split(Table.headings(single_table), "\t");
	for (i = 0; i < Table.size(single_table); i++) {
		for (j = 0; j < headings.length; j++) {
			value = Table.get(headings[j], i, single_table);
			// "value" might be a string
			if (isNaN(value)) {
				value = Table.getString(headings[j], i, single_table);
			}
			Table.set(headings[j], i + last_table_size, value, all_results_table);
		}
	}
	// add a line at the end of the table
	current_size = Table.size(all_results_table);
	headings_concat = split(Table.headings(all_results_table), "\t");
	for (j = 0; j < headings_concat.length; j++) {
		Table.set(headings_concat[j], current_size, "-------------", all_results_table);
	}
	Table.update(all_results_table);
}


function concatTablesFromResults(all_results_table) {
	// an attempet at a modular creation of table concatenation
	
	// get current big table size
	last_table_size = Table.size(all_results_table);
	
	// get headings from Resuts table
	headings = split(String.getResultsHeadings, "\t");
	for (i = 0; i < nResults(); i++) {
		for (j = 0; j < headings.length; j++) {
			value = getResult(headings[j], i);
			// "value" might be a string
			if (isNaN(value)) {
				value = getResultString(headings[j], i);
			}
			Table.set(headings[j], i + last_table_size, value, all_results_table);
		}
	}
	
	Table.update(all_results_table);
}


function runtime(start_time, end_time) { 
	// print time in minutes and seconds
	total_time = end_time - start_time;
	minutes_remanider = total_time % (60 * 1000);
	minutes = (total_time - minutes_remanider) / (60 * 1000);
	seconds = minutes_remanider / 1000;
	print("Macro runtime was " + minutes + " minutes and " + seconds + " seconds.");
}

