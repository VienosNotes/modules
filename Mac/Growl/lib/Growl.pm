use v6;

class Growl {

    has Str $.app_name;

    method new (Str $app_name = "Perl6 Growl Library") {
        self.bless(*, app_name => $app_name);
    }

    method register {
        my Str $message = 'osascript <<EOF
tell application "GrowlHelperApp"
register as application "' ~ $!app_name ~ '" all notifications {"Notification"} default notifications {"Notification"}
end tell
EOF';
        return qqx/$message/;
    }

    method notify (Str $title, Str $dscr, Int $priority = 0, Bool :$sticky = False) {
        my $message = 'osascript <<EOF
tell application "GrowlHelperApp"
notify with name "Notification" title "' ~ $title ~'" description "' ~ $dscr ~ '" application name "' ~ $!app_name ~ '" icon of application "Terminal" sticky ' ~ ($sticky??"yes"!!"no") ~ ' priority ' ~ $priority.Str ~
'
end tell
EOF';

        return qqx/$message/;
    }
}
