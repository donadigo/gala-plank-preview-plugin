//
//  Copyright (C) 2017 Adam Bieńkowski
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

public class Gala.Plugins.Plank.Main : Gala.Plugin
{
    const string DBUS_NAME = "org.pantheon.gala.plank";
	const string DBUS_PATH = "/org/pantheon/gala/plank";

	Gala.WindowManager? wm = null;
	DBusConnection? dbus_connection = null;

	public override void initialize (Gala.WindowManager wm)
	{
		this.wm = wm;

		Bus.own_name (BusType.SESSION,
                      DBUS_NAME,
                      BusNameOwnerFlags.NONE,
                      on_bus_aquired,
                      null,
		() => warning ("Aquiring \"%s\" failed.", DBUS_NAME));
	}

	public override void destroy ()
	{
		try {
            if (dbus_connection != null) {
                dbus_connection.close_sync ();
            }
        } catch (Error e) {
            warning ("Closing DBus service failed: %s", e.message);
		}
	}

	void on_bus_aquired (DBusConnection connection)
	{
        dbus_connection = connection;

        try {
            var server = new DBusServer (wm);
			server.track.connect (on_track);
			server.untrack.connect (on_untrack);

            dbus_connection.register_object (DBUS_PATH, server);

            debug ("DBus service registered.");
        } catch (Error e) {
            warning ("Registering DBus service failed: %s", e.message);
        }
	}

	void on_track (Clutter.Actor actor)
	{
		track_actor (actor);
	}

	void on_untrack (Clutter.Actor actor)
	{
		untrack_actor (actor);
		update_region ();
	}
}

public Gala.PluginInfo register_plugin () {
	return {
		"plank-plugin",                    // the plugin's name
		"Adam Bieńkowski <donadigos159@gmail.com>", // you, the author
		typeof (Gala.Plugins.Plank.Main),  // the type of your plugin class

		Gala.PluginFunction.ADDITION,         // the function which your plugin
		                                      // fulfils, ADDITION means nothing
		                                      // specific

		Gala.LoadPriority.IMMEDIATE           // indicates whether your plugin's
		                                      // start can be delayed until gala
		                                      // has loaded the important stuff or
		                                      // if you want your plugin to start
		                                      // right away. False means wait.
	};
}
