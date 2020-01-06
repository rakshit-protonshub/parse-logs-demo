module Api
  module V1
  	class LogsController < ApplicationController
			require 'csv'
			require 'json'
			include LogsHelper
	
			def read_log_file
				# Reading and converting CSV to JSON
				data_csv_to_json = parse_csv(params[:csv_file])
				
				# Reading JSON file
				data_json = parse_json(params[:json_file])

				final_json = data_csv_to_json + data_json

				# Sorting Chronologically
				if params[:sort].downcase == "asc"
					final_json = final_json.sort_by{ |row| row['Date-time'] }
				elsif params[:sort].downcase == "desc"
					final_json = final_json.sort_by{ |row| row['Date-time'] }.reverse
				end
				
				# Final Merged Files (In seperate thread)
				final_csv = csv_from_json(final_json)
				
				send_file CSV.open('./final_csv.csv').path, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename= final_csv.csv"
			end
		end
	end
end