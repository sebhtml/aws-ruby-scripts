#!/usr/bin/env ruby

require 'csv'

fileName=ARGV[0]


lineNumber=0

projects=Hash.new

CSV.foreach(fileName) do |tokens|

	lineNumber+=1

	if lineNumber<=2
		next
	end

	i=0
	while i<tokens.size
		#puts i.to_s+" --> "+tokens[i].to_s
		i+=1
	end

	productCode=tokens[12]
	usageType=tokens[15]
	usageQuantity=tokens[22].to_s
	totalCost=tokens[29].to_f
	project=tokens[30]

	if project.nil?
		project="not-classified"
	end

	if not projects.has_key? project
		projects[project]=Array.new
	end

	if productCode.nil?
		next
	end

	projects[project].push([productCode,usageType,usageQuantity,totalCost])

end

puts "<html><head><title>Cost Allocation Report</title></head><body><table border='1'>"
puts "<caption>Pivot table for Cost Allocation Report on AWS
<br />
File from AWS S3: "+fileName+"</caption><tbody>"

projects.each do |project, data|

	puts "<tr><td colspan='5'>"
	puts "<b>Project="+project+"</b>"
	puts "<tr><th>Product Code</th><th>Usage Type</th><th>Units</th><th>Usage Quantity</th><th>Total Cost ($)</th></tr>"
	puts "</td></tr>"
	sum=0.0

	data.each do |item|
		productCode=item[0]
		usageType=item[1]
		usageQuantity=item[2]
		totalCost=item[3]
		sum+=totalCost

		puts "<tr><td>"+productCode.to_s+"</td><td>"+usageType.to_s+"</td>"

		units=""

		if usageType=="EBS:VolumeUsage"
			units="GB-months"
		elsif usageType=="EBS:VolumeIOUsage"
			units="I/O requests"
		elsif usageType.index("SpotUsage:")== 0
			units="instance-hours"
		elsif usageType.index("BoxUsage")==0
			units="instance-hours"
		elsif usageType=="Requests-Tier1"
			units="HTTP requests"
		elsif usageType=="Requests-Tier2"
			units="HTTP requests"
		elsif usageType=="DataTransfer-Out-Bytes"
			units="GB"
		elsif usageType=="TimedStorage-ByteHrs"
			units="GB"
		elsif usageType=="DataTransfer-In-Bytes"
			units="GB"
		elsif usageType=="DataTransfer-Regional-Bytes"
			units="GB"
		end

		puts "<td>"+units+"</td>"
		puts "<td>"+usageQuantity+"</td><td>"+totalCost.to_s+"</td></tr>"
	end


	puts "<tr><td></td><td></td><td></td><td>Total=</td><td>"+sum.to_s+"</td></tr>"

end

puts "</tbody></table>"

