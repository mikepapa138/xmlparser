class ConverterController < ApplicationController

  before_action :validates_format, only: [:import]

  def validates_format
    
    accepted_formats = [".txt", ".csv"]

    if params[:file] and !accepted_formats.include? File.extname(params[:file].original_filename)
      flash[:error] = "This file formate is not allowed!"
      render :template => "converter/index"
    end

  end

  def import

    @quize = Converter.importXml(params[:file]) if [".csv"].include? File.extname(params[:file].original_filename)
    
    @quize = Converter.importText(params[:file]) if [".txt"].include? File.extname(params[:file].original_filename)

    # render :template => "converter/show.xml", :type => :builder
    
    file = params[:file].original_filename
    file_name = File.basename(file,File.extname(file))

    stream = render_to_string(:template=>"converter/show.xml" )  
    send_data(stream, :type=>"text/xml",:filename => "#{file_name}.xml")
  end
end
