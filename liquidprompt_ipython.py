import os
import getpass

# TODO: load the liquidpromptrc config?

class _lp_(object):


    styles = {"normal":0, "bold":1, "faint":2, "italic":3, "underline":4, "blink":5, "rapid_blink":6,
    "reverse":7, "conceal":8 }
    colors_mode8 = {"black":0, "red":1, "green":2, "yellow":3, "blue":4, "magenta":5, "cyan":6, "white":7}
    modes = {8:";", 256:";38;5;"}

    def color( self, text, color, style="normal" ):
        """Return the given text, surrounded by the given color ANSI markers."""
        # Special characters.
        start = "\033["
        stop = "\033[0m"

        # Convert the color code.
        cs = str(self.styles[style])

        # "normal" is a special keyword for no color
        if color == "normal":
            mode = 8
            cc = ""
        else:
            # 8 colors modes
            if color in self.colors_mode8:
                mode = 8
                cc = str( 30 + self.colors_mode8[color] )

            # 256 colors mode
            else:
                mode = 256
                cc = str( color )

        return start + cs + self.modes[mode] + cc + "m" + text + stop


    def sl(self, text):
        """Insert a space at left"""
        return text+" "
    def sb(self,text):
        """Insert a space at left and right"""
        return " "+text+" "
    def sr(self,text):
        """Insert a space at right"""
        return " "+text


    def __str__(self):
        raise NotImplemented


class _lp_smart_mark(_lp_):
    mark=">>>"

    def __str__(self):
        return self.sb( self.color( self.mark, "green", "bold" ) )

    def __call__(self,mark):
        self.mark=mark


class _lp_user(_lp_):
    ALWAYS=1
    COLOR_ROOT="yellow"
    COLOR_LOGGED="white"
    COLOR_ALT="white"

    def __str__(self):
        # current user
        cur = getpass.getuser()

        # logged user
        # WARNING: Unix only
        log = os.getlogin()

        if cur != 'root':
            if cur != log:
                return self.color( cur, self.COLOR_ALT )
            else:
                if self.ALWAYS:
                    return self.color( cur, self.COLOR_LOGGED )
                else:
                    return ""
        else:
            return self.color( cur, self.COLOR_ROOT )


LP_USER = _lp_user();      del _lp_user
LP_MARK = _lp_smart_mark();del _lp_smart_mark

del _lp_

