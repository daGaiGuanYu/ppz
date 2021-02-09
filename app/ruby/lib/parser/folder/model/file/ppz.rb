module PPZ::Folder
  class PPZFileModel < AbstractFileModel
    def _compile dir_out
      parser = PPZ::FileDocParser.new @path
      html_str = parser.get_model.to_html
      PPZ::Func::write_to_file (dir_out + '/' + @name + '.html'), html_str
    end
  end
end