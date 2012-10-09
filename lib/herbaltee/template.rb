module Herbaltee
  class Template
    attr_reader :content, :vars

    def initialize(file, vars)
      @content = File.open(file).read
      @vars = vars
    end

    def blank
      binding
    end

    def binder(vars = {})
      b = blank
      vars.each {|k,v| define_singleton_method("ht_#{k}") { v }}
      b
    end

    def method_missing(meth, *args)
      if respond_to?("ht_#{meth}")
        send("ht_#{meth}")
      else
        super
      end
    end

    def render
      b = binder(@vars)
      template = ERB.new(@content)
      template.result(b)
    end

    def write(target)
      if File.exists?(target)
        FileUtils.cp(target, [target, Herbaltee.now].join('.'))
      end
      File.open(target, 'w') {|f| f.write(render)}
    end
  end
end
