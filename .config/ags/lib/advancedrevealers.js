const { Gdk, Gtk } = imports.gi;
import { App, SCREEN_WIDTH, SCREEN_HEIGHT, Service, Utils, Variable, Widget } from '../imports.js';
const { Box, Button, Entry, EventBox, Icon, Label, Revealer, Scrollable, Stack } = Widget;

export const MarginRevealer = ({
    transition = 'slide_down',
    child,
    revealChild,
    showClass = 'element-show', // These are for animation curve, they don't really hide
    hideClass = 'element-hide', // Don't put margins in these classes!
    extraProperties = [],
    ...rest
}) => {
    const widget = Scrollable({
        ...rest,
        css: `min-height: 0px;`,
        properties: [
            ['revealChild', true], // It'll be set to false after init if it's supposed to hide
            ['transition', transition],
            ['show', (self) => {
                if (self._revealChild) return;
                self.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.NEVER);
                child.toggleClassName(hideClass, false);
                child.toggleClassName(showClass, true);
                self._revealChild = true;
                child.css = 'margin: 0px;';
            }],
            ['hide', (self) => {
                if (!self._revealChild) return;
                child.toggleClassName(hideClass, true);
                child.toggleClassName(showClass, false);
                self._revealChild = false;
                if (self._transition == 'slide_left')
                    child.css = `margin-right: -${child.get_allocated_width()}px;`;
                else if (self._transition == 'slide_right')
                    child.css = `margin-left: -${child.get_allocated_width()}px;`;
                else if (self._transition == 'slide_up')
                    child.css = `margin-bottom: -${child.get_allocated_height()}px;`;
                else if (self._transition == 'slide_down')
                    child.css = `margin-top: -${child.get_allocated_height()}px;`;
            }],
            ['toggle', (self) => {
                console.log('toggle');
                if (self._revealChild) self._hide(self);
                else self._show(self);
            }],
            ...extraProperties,
        ],
        setup: (self) => {
            if (!revealChild)
                self.set_policy(Gtk.PolicyType.ALWAYS, Gtk.PolicyType.ALWAYS);
            else
                self.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.NEVER);
            self.child = child;
        },
    });
    child.toggleClassName(`${revealChild ? showClass : hideClass}`, true);
    return widget;
}

// TODO: Allow reveal update. Currently this just helps at declaration
export const DoubleRevealer = ({
    transition1 = 'slide_right',
    transition2 = 'slide_left',
    duration1 = 150,
    duration2 = 150,
    child,
    revealChild,
}) => {
    return Revealer({
        transition: transition1,
        transitionDuration: duration1,
        revealChild: revealChild,
        child: Revealer({
            transition: transition2,
            transitionDuration: duration2,
            revealChild: revealChild,
            child: child,
        })
    })
}
