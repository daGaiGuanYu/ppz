# 解析一个 .ppz 文档（可以是一个文件、字符串）

require_relative '../../../func/util'
require_relative '../common/context/doc'
require_relative '../../model/section/leaf'
require_relative '../../model/section/root'
require_relative '../../model/p/index'
require_relative '../../model/list/item/unordered'
require_relative '../../model/list/wrapper/unordered'

class AbstractDocParser
  def initialize
    @context = DocContext.new RootSectionModel.new
  end

  def get_model
    loop do
      line = readline
      break unless line != nil
      handle_line line
    end
    @context.root
  end

  private
    def handle_line line
      Func.escape_ppz! line

      if target = LeafSectionModel.from_line(line)
      # section
        # 检查 level
        loop do
          break if @context.level < target.level
          @context.pop
        end
      elsif target = UnorderedListItemModel.from_line(line)
      # 列表
        unless @context.head.is_a? UnorderedListWrapperModel # 如果当前不在一个 无序列表 里
          wrapper = UnorderedListWrapperModel.new # 就整一个无序列表
          @context.pop_to_section # 找到最近的 section
          @context.head.append wrapper # 加入 wrapper
          @context.append wrapper # wrapper 入上下文栈
        end
      # p
      else
        @context.pop_to_section # 找到最近的 section
        target = PModel.new line
      end

      # 添加到父级 model
      @context.head.append target

      # 推入上下文
      if target.is_a? AbstractWrapperModel
        @context.append target 
      end
    end
end