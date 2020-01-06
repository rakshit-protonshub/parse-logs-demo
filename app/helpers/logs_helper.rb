module LogsHelper
	def parse_json(json_params)
		json_file = File.read(json_params.path)
		data_json = JSON.parse(json_file)
	end

	def parse_csv(csv_param)
		lines = CSV.open(csv_param.path).readlines
		keys = lines.delete lines.first
		
		# Reading CSV file
		File.open('./converted_json.json', 'w') do |f|
			data = lines.map do |values|
				Hash[keys.zip(values)]
			end
			f.puts JSON.pretty_generate(data)
		end
		csv_to_json_file = File.read('./converted_json.json')
		data_csv_to_json = JSON.parse(csv_to_json_file)
	end

	def csv_from_json(final_json)
		final_csv = CSV.open('./final_csv.csv', 'wb') do |csv|
		  final_json.each do |m|
	      row = []
	      row << m["Date-time"]
	      row << m["Text"]
	      row << m["Origin-system"]
	      csv << row
	    end
		end
		final_csv
	end
end
