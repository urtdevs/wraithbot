# Copyright 2010-2011 undeadzy (q3urt.undead@gmail.com). All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY ``AS IS'' AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
# EVENT SHALL UNDEADZY OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

package Util::FTW;

use strict;
use warnings;
use DateTime;
use DateTime::Format::Natural;

use Readonly;

use version 0.77; our $VERSION = version->declare('v0.0.1');

# You shouldn't need to change these
Readonly our $TIME_ZONE => 'America/New_York';
Readonly our $TS_MATCH => "Next Tuesday at 21:30";
Readonly our $CTF_MATCH => "Next Sunday at 21:00";

sub new {
    my ($class) = @_;

    my $self = {
fmt => DateTime::Format::Natural->new(time_zone => $TIME_ZONE),
    };

    bless( $self, $class );
    return $self;
}

sub current_time {
    my ($self) = @_;

    my $now = DateTime->now(time_zone => $TIME_ZONE);
    return "FTWGL time (America/New_York) is: " . $now;
}

sub next_ts {
    my ($self) = @_;

    return $self->_next_type("TS", $TS_MATCH);
}

sub next_ctf {
    my ($self) = @_;

    return $self->_next_type("CTF", $CTF_MATCH);
}

sub _next_type {
    my ($self, $type, $match) = @_;

    my $now = DateTime->now(time_zone => $TIME_ZONE);
    my $game = $self->{fmt}->parse_datetime($match);
    my $game_diff = $game - $now;

    if ( $game_diff->in_units('days') >= 6
&& $game_diff->days >= 6 && $game_diff->hours >= 22 ) {
return "Current $type matches are in progress!";

    } else {
return "Next FTWGL $type match is in "
               . $game_diff->days . " " . ($game_diff->days == 1 ? "day" : "days") . ", "
               . $game_diff->hours . " " . ($game_diff->hours == 1 ? "hour" : "hours") . ", "
               . $game_diff->minutes . " " . ($game_diff->minutes == 1 ? "minute" : "minutes");
    }
}

sub next_matches {
    my ($self) = @_;

    return ($self->next_ts(), $self->next_ctf());
}

1;
