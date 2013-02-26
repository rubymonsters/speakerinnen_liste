require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class BoringVendorProvidedCLI < Thor
  desc "boring", "do boring stuff"
  def boring
    puts "bored. <yawn>"
  end
end

class ExcitingPluginCLI < Thor
  desc "hooray", "say hooray!"
  def hooray
    puts "hooray!"
  end

  desc "fireworks", "exciting fireworks!"
  def fireworks
    puts "kaboom!"
  end
end

class SuperSecretPlugin < Thor
  default_task :squirrel

  desc "squirrel", "All of secret squirrel's secrets"
  def squirrel
    puts "I love nuts"
  end
end

class GroupPlugin < Thor::Group
  desc "part one"
  def part_one
    puts "part one"
  end

  desc "part two"
  def part_two
    puts "part two"
  end
end

class ClassOptionGroupPlugin < Thor::Group
  class_option :who,
    :type => :string,
    :aliases => "-w",
    :default => "zebra"
end

class CompatibleWith19Plugin < ClassOptionGroupPlugin
  desc "animal"
  def animal
    p options[:who]
  end
end

class PluginWithDefault < Thor
  desc "say MSG", "print MSG"
  def say(msg)
    puts msg
  end

  default_task :say
end

class PluginWithDefaultMultipleArguments < Thor
  desc "say MSG [MSG]", "print multiple messages"
  def say(*args)
    puts args
  end

  default_task :say
end

class PluginWithDefaultTaskAndDeclaredArgument < Thor
  desc "say MSG [MSG]", "print multiple messages"
  argument :msg
  def say
    puts msg
  end

  default_task :say
end

BoringVendorProvidedCLI.register(
  ExcitingPluginCLI,
  "exciting",
  "do exciting things",
  "Various non-boring actions")

BoringVendorProvidedCLI.register(
  SuperSecretPlugin,
  "secret",
  "secret stuff",
  "Nothing to see here. Move along.",
  :hide => true)

BoringVendorProvidedCLI.register(
  GroupPlugin,
  'groupwork',
  "Do a bunch of things in a row",
  "purple monkey dishwasher")

BoringVendorProvidedCLI.register(
  CompatibleWith19Plugin,
  'zoo',
  "zoo [-w animal]",
  "Shows a provided animal or just zebra")

BoringVendorProvidedCLI.register(
  PluginWithDefault,
  'say',
  'say message',
  'subcommands ftw')

BoringVendorProvidedCLI.register(
  PluginWithDefaultMultipleArguments,
  'say_multiple',
  'say message',
  'subcommands ftw')

BoringVendorProvidedCLI.register(
  PluginWithDefaultTaskAndDeclaredArgument,
  'say_argument',
  'say message',
  'subcommands ftw')

describe ".register-ing a Thor subclass" do
  it "registers the plugin as a subcommand" do
    fireworks_output = capture(:stdout) { BoringVendorProvidedCLI.start(%w[exciting fireworks]) }
    expect(fireworks_output).to eq("kaboom!\n")
  end

  it "includes the plugin's usage in the help" do
    help_output = capture(:stdout) { BoringVendorProvidedCLI.start(%w[help]) }
    expect(help_output).to include('do exciting things')
  end

  it "invokes the default task correctly" do
    output = capture(:stdout) { BoringVendorProvidedCLI.start(%w[say hello]) }
    expect(output).to include("hello")
  end

  it "invokes the default task correctly with multiple args" do
    output = capture(:stdout) { BoringVendorProvidedCLI.start(%w[say_multiple hello adam]) }
    expect(output).to include("hello")
    expect(output).to include("adam")
  end

  it "invokes the default task correctly with a declared argument" do
    output = capture(:stdout) { BoringVendorProvidedCLI.start(%w[say_argument hello]) }
    expect(output).to include("hello")
  end

  context "when $thor_runner is false" do
    it "includes the plugin's subcommand name in subcommand's help" do
      begin
        $thor_runner = false
        help_output = capture(:stdout) { BoringVendorProvidedCLI.start(%w[exciting]) }
        expect(help_output).to include('thor exciting_plugin_c_l_i fireworks')
      ensure
        $thor_runner = true
      end
    end
  end

  context "when hidden" do
    it "omits the hidden plugin's usage from the help" do
      help_output = capture(:stdout) { BoringVendorProvidedCLI.start(%w[help]) }
      expect(help_output).not_to include('secret stuff')
    end

    it "registers the plugin as a subcommand" do
      secret_output = capture(:stdout) { BoringVendorProvidedCLI.start(%w[secret squirrel]) }
      expect(secret_output).to eq("I love nuts\n")
    end
  end
end

describe ".register-ing a Thor::Group subclass" do
  it "registers the group as a single command" do
    group_output = capture(:stdout) { BoringVendorProvidedCLI.start(%w[groupwork]) }
    expect(group_output).to eq("part one\npart two\n")
  end
end

describe "1.8 and 1.9 syntax compatibility" do
  it "is compatible with both 1.8 and 1.9 syntax w/o task options" do
    group_output = capture(:stdout) { BoringVendorProvidedCLI.start(%w[zoo]) }
    expect(group_output).to match(/zebra/)
  end

  it "is compatible with both 1.8 and 1.9 syntax w/task options" do
    group_output = capture(:stdout) { BoringVendorProvidedCLI.start(%w[zoo -w lion]) }
    expect(group_output).to match(/lion/)
  end
end
