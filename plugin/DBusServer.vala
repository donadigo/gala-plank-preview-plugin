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

[DBus (name = "org.pantheon.gala.plank")]
public class Gala.Plugins.Plank.DBusServer : Object
{
    Gala.WindowManager wm;
    WindowPreviewActor? preview_actor;
    string prev_launcher;

    [DBus (visible = false)]
    public signal void track (Clutter.Actor actor);

    [DBus (visible = false)]
    public signal void untrack (Clutter.Actor actor);

    public signal void disable_preview_mode ();

    public DBusServer (Gala.WindowManager wm)
    {
        this.wm = wm;
    }

    public bool get_preview_is_hovered ()
    {
        if (preview_actor != null) {
            return preview_actor.is_hovered;
        }

        return false;
    }

    public bool show_window_preview (string launcher, int x, int y)
    {
        if (launcher == "") {
            destroy_preview ();
            prev_launcher = launcher;
            return false;
        } else {
            unowned Bamf.Application? application = get_application_for_launcher (launcher);
            if (application == null) {
                if (prev_launcher != launcher) {
                    destroy_preview ();
                }

                prev_launcher = launcher;
                return false;
            }

            if (preview_actor != null) {
                if (preview_actor.set_application (application)) {
                    preview_actor.set_preview_position (x, y);
                    prev_launcher = launcher;
                    return true;
                } else {
                    destroy_preview ();
                    prev_launcher = launcher;
                    return false;
                }

            } else {
                preview_actor = new WindowPreviewActor (wm);
                if (preview_actor.set_application (application)) {
                    preview_actor.set_preview_position (x, y);
                    preview_actor.closed.connect (on_preview_actor_closed);
        
                    track (preview_actor);
                    wm.ui_group.add_child (preview_actor);
                    preview_actor.open ();
                    prev_launcher = launcher;
                    return true;
                } else {
                    if (prev_launcher != launcher) {
                        destroy_preview ();
                    }

                    prev_launcher = launcher;
                    return false;
                }
            }
        }
    }

    void on_preview_actor_closed ()
    {
        destroy_preview ();
        disable_preview_mode ();
    }

    void destroy_preview ()
    {
        if (preview_actor == null) {
            return;
        }

        untrack (preview_actor);
        preview_actor.hide ();
        preview_actor = null;
    }

    static unowned Bamf.Application? get_application_for_launcher (string launcher)
    {
        try {
            string path = Filename.from_uri (launcher);
            return Bamf.Matcher.get_default ().get_application_for_desktop_file (path, false);
        } catch (Error e) {
            return null;
        }
    }
}