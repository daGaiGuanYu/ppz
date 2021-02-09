require 'pathname'

module PPZMain
  CURRENT_PATH = File.dirname __FILE__
  WORK_DIRECTORY = Pathname Dir.pwd
  CSS_FILE_PATH = (Pathname CURRENT_PATH) + '../asset/style/ppz.css'

  class Util
    class << self
      def get_in_and_out
        target_in, target_out = ARGV

        # 输入文件
        abort '要编译哪那个文件？请告诉我' unless target_in # 检查参数存在
        target_in = (WORK_DIRECTORY + target_in).to_s # 绝对路径
        unless File.exist? target_in # 不存在的话，看看加上 .ppz 后是否存在
          target_in += '.ppz'
          abort target_in[0..-5] + ' 不存在' unless File.exist? target_in # 还不存在的话，就说明是写错了
        end
        is_folder = File.directory? target_in

        # 输出文件
        unless target_out
          # 从输入文件获取文件名
          target_out = ((/(.*).ppz$/.match target_in)?$1:target_in) + '.pp'
        end
        target_out = WORK_DIRECTORY + target_out
        # + 检查上级文件夹是否存在
        upper_dir = (target_out + '..').to_s
        abort upper_dir + ' 目录不存在' unless Dir.exist? upper_dir
        # + 检查文件夹：有则检查里面有没有文件；无则创建文件夹
        target_out = target_out.to_s
        if Dir.exist? target_out
          abort target_out + ' 不是一个空文件夹' unless (Dir.children target_out).size == 0
        else
          Dir.mkdir target_out
        end
        
        # 去除文件夹路径最后的斜线
        if ['/', '\\'].include? target_in[-1]
          target_in = target_in[0...-1]
        end
        # 去除文件夹路径最后的斜线
        if ['/', '\\'].include? target_out[-1]
          target_out = target_out[0...-1]
        end
        
        [target_in, target_out, is_folder]
      end
    end
  end
end