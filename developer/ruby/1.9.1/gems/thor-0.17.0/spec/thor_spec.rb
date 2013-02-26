require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Thor do
  describe "#method_option" do
    it "sets options to the next method to be invoked" do
      args = ["foo", "bar", "--force"]
      arg, options = MyScript.start(args)
      expect(options).to eq({ "force" => true })
    end

    describe ":lazy_default" do
      it "is absent when option is not specified" do
        arg, options = MyScript.start(["with_optional"])
        expect(options).to eq({})
      end

      it "sets a default that can be overridden for strings" do
        arg, options = MyScript.start(["with_optional", "--lazy"])
        expect(options).to eq({ "lazy" => "yes" })

        arg, options = MyScript.start(["with_optional", "--lazy", "yesyes!"])
        expect(options).to eq({ "lazy" => "yesyes!" })
      end

      it "sets a default that can be overridden for numerics" do
        arg, options = MyScript.start(["with_optional", "--lazy-numeric"])
        expect(options).to eq({ "lazy_numeric" => 42 })

        arg, options = MyScript.start(["with_optional", "--lazy-numeric", 20000])
        expect(options).to eq({ "lazy_numeric" => 20000 })
      end

      it "sets a default that can be overridden for arrays" do
        arg, options = MyScript.start(["with_optional", "--lazy-array"])
        expect(options).to eq({ "lazy_array" => %w[eat at joes] })

        arg, options = MyScript.start(["with_optional", "--lazy-array", "hello", "there"])
        expect(options).to eq({ "lazy_array" => %w[hello there] })
      end

      it "sets a default that can be overridden for hashes" do
        arg, options = MyScript.start(["with_optional", "--lazy-hash"])
        expect(options).to eq({ "lazy_hash" => {'swedish' => 'meatballs'} })

        arg, options = MyScript.start(["with_optional", "--lazy-hash", "polish:sausage"])
        expect(options).to eq({ "lazy_hash" => {'polish' => 'sausage'} })
      end
    end

    describe "when :for is supplied" do
      it "updates an already defined task" do
        args, options = MyChildScript.start(["animal", "horse", "--other=fish"])
        expect(options[:other]).to eq("fish")
      end

      describe "and the target is on the parent class" do
        it "updates an already defined task" do
          args = ["example_default_task", "my_param", "--new-option=verified"]
          options = Scripts::MyScript.start(args)
          expect(options[:new_option]).to eq("verified")
        end

        it "adds a task to the tasks list if the updated task is on the parent class" do
          expect(Scripts::MyScript.tasks["example_default_task"]).to be
        end

        it "clones the parent task" do
          expect(Scripts::MyScript.tasks["example_default_task"]).not_to eq(MyChildScript.tasks["example_default_task"])
        end
      end
    end
  end

  describe "#default_task" do
    it "sets a default task" do
      expect(MyScript.default_task).to eq("example_default_task")
    end

    it "invokes the default task if no command is specified" do
      expect(MyScript.start([])).to eq("default task")
    end

    it "invokes the default task if no command is specified even if switches are given" do
      expect(MyScript.start(["--with", "option"])).to eq({"with"=>"option"})
    end

    it "inherits the default task from parent" do
      expect(MyChildScript.default_task).to eq("example_default_task")
    end
  end

  describe "#stop_on_unknown_option!" do
    my_script = Class.new(Thor) do
      class_option "verbose",   :type => :boolean
      class_option "mode",      :type => :string

      stop_on_unknown_option! :exec

      desc "exec", "Run a command"
      def exec(*args)
        return options, args
      end

      desc "boring", "An ordinary task"
      def boring(*args)
        return options, args
      end
    end

    it "passes remaining args to task when it encounters a non-option" do
      expect(my_script.start(%w[exec command --verbose])).to eq [{}, ["command", "--verbose"]]
    end

    it "passes remaining args to task when it encounters an unknown option" do
      expect(my_script.start(%w[exec --foo command --bar])).to eq [{}, ["--foo", "command", "--bar"]]
    end

    it "still accepts options that are given before non-options" do
      expect(my_script.start(%w[exec --verbose command --foo])).to eq [{"verbose" => true}, ["command", "--foo"]]
    end

    it "still accepts options that require a value" do
      expect(my_script.start(%w[exec --mode rashly command])).to eq [{"mode" => "rashly"}, ["command"]]
    end

    it "still passes everything after -- to task" do
      expect(my_script.start(%w[exec -- --verbose])).to eq [{}, ["--verbose"]]
    end

    it "does not affect ordinary tasks"  do
      expect(my_script.start(%w[boring command --verbose])).to eq [{"verbose" => true}, ["command"]]
    end

    context "when provided with multiple task names" do
      klass = Class.new(Thor) do
        stop_on_unknown_option! :foo, :bar
      end
      it "affects all specified tasks" do
        expect(klass.stop_on_unknown_option?(mock :name => "foo")).to be_true
        expect(klass.stop_on_unknown_option?(mock :name => "bar")).to be_true
        expect(klass.stop_on_unknown_option?(mock :name => "baz")).to be_false
      end
    end

    context "when invoked several times" do
      klass = Class.new(Thor) do
        stop_on_unknown_option! :foo
        stop_on_unknown_option! :bar
      end
      it "affects all specified tasks" do
        expect(klass.stop_on_unknown_option?(mock :name => "foo")).to be_true
        expect(klass.stop_on_unknown_option?(mock :name => "bar")).to be_true
        expect(klass.stop_on_unknown_option?(mock :name => "baz")).to be_false
      end
    end
  end

  describe "#map" do
    it "calls the alias of a method if one is provided" do
      expect(MyScript.start(["-T", "fish"])).to eq(["fish"])
    end

    it "calls the alias of a method if several are provided via .map" do
      expect(MyScript.start(["-f", "fish"])).to eq(["fish", {}])
      expect(MyScript.start(["--foo", "fish"])).to eq(["fish", {}])
    end

    it "inherits all mappings from parent" do
      expect(MyChildScript.default_task).to eq("example_default_task")
    end
  end

  describe "#desc" do
    it "provides description for a task" do
      content = capture(:stdout) { MyScript.start(["help"]) }
      expect(content).to match(/thor my_script:zoo\s+# zoo around/m)
    end

    it "provides no namespace if $thor_runner is false" do
      begin
        $thor_runner = false
        content = capture(:stdout) { MyScript.start(["help"]) }
        expect(content).to match(/thor zoo\s+# zoo around/m)
      ensure
        $thor_runner = true
      end
    end

    describe "when :for is supplied" do
      it "overwrites a previous defined task" do
        expect(capture(:stdout) { MyChildScript.start(["help"]) }).to match(/animal KIND \s+# fish around/m)
      end
    end

    describe "when :hide is supplied" do
      it "does not show the task in help" do
        expect(capture(:stdout) { MyScript.start(["help"]) }).not_to match(/this is hidden/m)
      end

      it "but the task is still invokcable not show the task in help" do
        expect(MyScript.start(["hidden", "yesyes"])).to eq(["yesyes"])
      end
    end
  end

  describe "#method_options" do
    it "sets default options if called before an initializer" do
      options = MyChildScript.class_options
      expect(options[:force].type).to eq(:boolean)
      expect(options[:param].type).to eq(:numeric)
    end

    it "overwrites default options if called on the method scope" do
      args = ["zoo", "--force", "--param", "feathers"]
      options = MyChildScript.start(args)
      expect(options).to eq({ "force" => true, "param" => "feathers" })
    end

    it "allows default options to be merged with method options" do
      args = ["animal", "bird", "--force", "--param", "1.0", "--other", "tweets"]
      arg, options = MyChildScript.start(args)
      expect(arg).to eq('bird')
      expect(options).to eq({ "force"=>true, "param"=>1.0, "other"=>"tweets" })
    end
  end

  describe "#start" do
    it "calls a no-param method when no params are passed" do
      expect(MyScript.start(["zoo"])).to eq(true)
    end

    it "calls a single-param method when a single param is passed" do
      expect(MyScript.start(["animal", "fish"])).to eq(["fish"])
    end

    it "does not set options in attributes" do
      expect(MyScript.start(["with_optional", "--all"])).to eq([nil, { "all" => true }, []])
    end

    it "raises an error if a required param is not provided" do
      expect(capture(:stderr) { MyScript.start(["animal"]) }.strip).to eq('thor animal requires at least 1 argument: "thor my_script:animal TYPE".')
    end

    it "raises an error if the invoked task does not exist" do
      expect(capture(:stderr) { Amazing.start(["animal"]) }.strip).to eq('Could not find task "animal" in "amazing" namespace.')
    end

    it "calls method_missing if an unknown method is passed in" do
      expect(MyScript.start(["unk", "hello"])).to eq([:unk, ["hello"]])
    end

    it "does not call a private method no matter what" do
      expect(capture(:stderr) { MyScript.start(["what"]) }.strip).to eq('Could not find task "what" in "my_script" namespace.')
    end

    it "uses task default options" do
      options = MyChildScript.start(["animal", "fish"]).last
      expect(options).to eq({ "other" => "method default" })
    end

    it "raises when an exception happens within the task call" do
      expect{ MyScript.start(["call_myself_with_wrong_arity"]) }.to raise_error(ArgumentError)
    end

    context "when the user enters an unambiguous substring of a command" do
      it "invokes a command" do
        expect(MyScript.start(["z"])).to eq(MyScript.start(["zoo"]))
      end

      it "invokes a command, even when there's an alias the resolves to the same command" do
        expect(MyScript.start(["hi"])).to eq(MyScript.start(["hidden"]))
      end

      it "invokes an alias" do
        expect(MyScript.start(["animal_pri"])).to eq(MyScript.start(["zoo"]))
      end
    end

    context "when the user enters an ambiguous substring of a command" do
      it "raises an exception that explains the ambiguity" do
        expect{ MyScript.start(["call"]) }.to raise_error(ArgumentError, 'Ambiguous task call matches [call_myself_with_wrong_arity, call_unexistent_method]')
      end

      it "raises an exception when there is an alias" do
        expect{ MyScript.start(["f"]) }.to raise_error(ArgumentError, 'Ambiguous task f matches [foo, fu]')
      end
    end

  end

  describe "#subcommand" do
    it "maps a given subcommand to another Thor subclass" do
      barn_help = capture(:stdout) { Scripts::MyDefaults.start(["barn"]) }
      expect(barn_help).to include("barn help [COMMAND]  # Describe subcommands or one specific subcommand")
    end

    it "passes commands to subcommand classes" do
      expect(capture(:stdout) { Scripts::MyDefaults.start(["barn", "open"]) }.strip).to eq("Open sesame!")
    end

    it "passes arguments to subcommand classes" do
      expect(capture(:stdout) { Scripts::MyDefaults.start(["barn", "open", "shotgun"]) }.strip).to eq("That's going to leave a mark.")
    end

    it "ignores unknown options (the subcommand class will handle them)" do
      expect(capture(:stdout) { Scripts::MyDefaults.start(["barn", "paint", "blue", "--coats", "4"])}.strip).to eq("4 coats of blue paint")
    end
  end

  describe "#help" do
    def shell
      @shell ||= Thor::Base.shell.new
    end

    describe "on general" do
      before do
        @content = capture(:stdout) { MyScript.help(shell) }
      end

      it "provides useful help info for the help method itself" do
        expect(@content).to match(/help \[TASK\]\s+# Describe available tasks/)
      end

      it "provides useful help info for a method with params" do
        expect(@content).to match(/animal TYPE\s+# horse around/)
      end

      it "uses the maximum terminal size to show tasks" do
        @shell.should_receive(:terminal_width).and_return(80)
        content = capture(:stdout) { MyScript.help(shell) }
        expect(content).to match(/aaa\.\.\.$/)
      end

      it "provides description for tasks from classes in the same namespace" do
        expect(@content).to match(/baz\s+# do some bazing/)
      end

      it "shows superclass tasks" do
        content = capture(:stdout) { MyChildScript.help(shell) }
        expect(content).to match(/foo BAR \s+# do some fooing/)
      end

      it "shows class options information" do
        content = capture(:stdout) { MyChildScript.help(shell) }
        expect(content).to match(/Options\:/)
        expect(content).to match(/\[\-\-param=N\]/)
      end

      it "injects class arguments into default usage" do
        content = capture(:stdout) { Scripts::MyScript.help(shell) }
        expect(content).to match(/zoo ACCESSOR \-\-param\=PARAM/)
      end
    end

    describe "for a specific task" do
      it "provides full help info when talking about a specific task" do
        expect(capture(:stdout) { MyScript.task_help(shell, "foo") }).to eq(<<-END)
Usage:
  thor my_script:foo BAR

Options:
  [--force]  # Force to do some fooing

do some fooing
  This is more info!
  Everyone likes more info!
END
      end

      it "raises an error if the task can't be found" do
        expect {
          MyScript.task_help(shell, "unknown")
        }.to raise_error(Thor::UndefinedTaskError, 'Could not find task "unknown" in "my_script" namespace.')
      end

      it "normalizes names before claiming they don't exist" do
        expect(capture(:stdout) { MyScript.task_help(shell, "name-with-dashes") }).to match(/thor my_script:name-with-dashes/)
      end

      it "uses the long description if it exists" do
        expect(capture(:stdout) { MyScript.task_help(shell, "long_description") }).to eq(<<-HELP)
Usage:
  thor my_script:long_description

Description:
  This is a really really really long description. Here you go. So very long.

  It even has two paragraphs.
HELP
      end

      it "doesn't assign the long description to the next task without one" do
        expect(capture(:stdout) {
          MyScript.task_help(shell, "name_with_dashes")
        }).not_to match(/so very long/i)
      end
    end

    describe "instance method" do
      it "calls the class method" do
        expect(capture(:stdout) { MyScript.start(["help"]) }).to match(/Tasks:/)
      end

      it "calls the class method" do
        expect(capture(:stdout) { MyScript.start(["help", "foo"]) }).to match(/Usage:/)
      end
    end
  end

  describe "when creating tasks" do
    it "prints a warning if a public method is created without description or usage" do
      expect(capture(:stdout) {
        klass = Class.new(Thor)
        klass.class_eval "def hello_from_thor; end"
      }).to match(/\[WARNING\] Attempted to create task "hello_from_thor" without usage or description/)
    end

    it "does not print if overwriting a previous task" do
      expect(capture(:stdout) {
        klass = Class.new(Thor)
        klass.class_eval "def help; end"
      }).to be_empty
    end
  end

  describe "edge-cases" do
    it "can handle boolean options followed by arguments" do
      klass = Class.new(Thor) do
        method_option :loud, :type => :boolean
        desc "hi NAME", "say hi to name"
        def hi(name)
          name.upcase! if options[:loud]
          "Hi #{name}"
        end
      end

      expect(klass.start(["hi", "jose"])).to eq("Hi jose")
      expect(klass.start(["hi", "jose", "--loud"])).to eq("Hi JOSE")
      expect(klass.start(["hi", "--loud", "jose"])).to eq("Hi JOSE")
    end

    it "passes through unknown options" do
      klass = Class.new(Thor) do
        desc "unknown", "passing unknown options"
        def unknown(*args)
          args
        end
      end

      expect(klass.start(["unknown", "foo", "--bar", "baz", "bat", "--bam"])).to eq(["foo", "--bar", "baz", "bat", "--bam"])
      expect(klass.start(["unknown", "--bar", "baz"])).to eq(["--bar", "baz"])
    end

    it "does not pass through unknown options with strict args" do
      klass = Class.new(Thor) do
        strict_args_position!

        desc "unknown", "passing unknown options"
        def unknown(*args)
          args
        end
      end

      expect(klass.start(["unknown", "--bar", "baz"])).to eq([])
      expect(klass.start(["unknown", "foo", "--bar", "baz"])).to eq(["foo"])
    end

    it "strict args works in the inheritance chain" do
      parent = Class.new(Thor) do
        strict_args_position!
      end

      klass = Class.new(parent) do
        desc "unknown", "passing unknown options"
        def unknown(*args)
          args
        end
      end

      expect(klass.start(["unknown", "--bar", "baz"])).to eq([])
      expect(klass.start(["unknown", "foo", "--bar", "baz"])).to eq(["foo"])
    end

    it "send as a task name" do
      expect(MyScript.start(["send"])).to eq(true)
    end
  end
end
