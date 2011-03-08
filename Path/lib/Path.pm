use v6;

class Path {

    has Str $!path;

    method new (Str $str) {

        my Str $path;

        if $str ~~ /^^\~.*$$/ { # "~" expansion
            $path = chomp qx ("echo " ~ $str);
        }

        elsif $str ~~ /^^\.$$/ { # relative path starts with "." expansion
            $path = cwd;
        }

        elsif $str ~~ /^^\.\/.*$$/ { # relative path starts with "./" expansion
            my Str $pwd = cwd;
            $path = $pwd ~ "/" ~ $str.substr(2);
        }

        elsif $str ~~ /^^(\.\.\/)+.*$$/ { # relative path starts with "../" expansion
            my Str $pwd = cwd;
            my Str $relpath = $str;

            while $relpath ~~ /^^\.\.\/.*$$/ {
                $relpath .= substr(3);
                $pwd ~~ /(.*)\//;
                $pwd = $0.Str;
            }
            $path = $pwd;
        }

        else {
            $path = $str;
        }

        if $str ~~ /.*\/$$/ { # chop $str if it ends with "/"
            $path .= chop;
        }

        self.bless(*, path => $path);
    }

    method basename {
        my Str $bname = $!path;
        $bname ~~ s/.*\///;
        return $bname;
    }

    method dirname {
        $!path ~~ /(.*)\//;
        return $0.Str;
    }

    method d {
        return $!path.IO ~~ :d;
    }

    method f {
        return $!path.IO ~~ :f;
    }

    method e {
        return $!path.IO ~~ :e;
    }

    method Str {
        return $!path;
    }

    method IO {
        return $!path.IO;
    }

    our Str multi method expand (Str $str) is export {
        return Path.new($str).Str;
    }
}

