require 'tty-command'

describe "Dokuwiki Charm:" do
  before(:each) do
    @cmd = TTY::Command.new(printer: :null)
  end

  describe "dokuwiki" do
    it "has the application directory" do
      expect(Dir.exists?(@cmd.run('config-get app_path').out.chomp)).to be true
    end
  end

  describe "nginx" do

    it "is installed" do
      expect(@cmd.run("dpkg -s nginx-full").success?).to be true
    end

    it "has a vhost enabled file" do
      expect(File.exists?('/etc/nginx/sites-enabled/default')).to be true
    end
  end

end
