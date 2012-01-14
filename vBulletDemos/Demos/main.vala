/*	public static int main (string[] args) {
	  
	    }
	    */
	    using Gtk;
using Gdk;
//
public static class DoDemos {

	public static int main (string[] args) {
	    Gtk.init (ref args);
	
	    var window = SetupWindow();
	
	    var DinoDemobutton = new Button.with_label ("Start BulletDinoDemo");
	    DinoDemobutton.clicked.connect (() => {
		   string[] arg = new string[] {"",""}; //I get errors if I try to use args from main
	       new Bullet.Demos.Dino.Demo(arg);
	    });
	    
	    var BasicDemobutton = new Button.with_label ("Start BasicDemo");
	    BasicDemobutton.clicked.connect (() => {
	       // new Bullet.Demos.BulletDinoDemo();
	       BasicDemobutton.label = "BasicDemo: This is a work in Progress, and has hardly been started.";

	    });
		    
	
		//Pixbuf pb;
		//pb = new Pixbuf.from_file("/usr/share/pixmaps/gnome-computer.png");
		//Gtk.Image i = new Gtk.Image.from_pixbuf(pixbuf);
	    var vbox = new VBox(true,0);
		Gtk.Image i = new Gtk.Image.from_file("/usr/share/pixmaps/gnome-computer.png");
		vbox.add (i);
	    vbox.add (DinoDemobutton);
	    vbox.add (BasicDemobutton);
	    
	    window.add(vbox);
	    window.show_all ();
	
	    Gtk.main ();
	    return 0;
	}
	
	public static Gtk.Window SetupWindow() {
		var window = new Gtk.Window ();
	    window.title = "First GTK+ Program";
	    window.set_default_size (300, 200);
	    window.position = WindowPosition.CENTER;
	    window.destroy.connect (Gtk.main_quit);
	    return window;
	}
}