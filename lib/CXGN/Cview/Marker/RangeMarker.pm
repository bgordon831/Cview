
=head1 NAME

CXGN::Cview::Marker::RangeMarker - a class to draw markers that represent ranges

=head1 DESCRIPTION

CXGN::Cview::Marker::RangeMarker inherits from L<CXGN::Cview::Marker>.

my $m = CXGN::Cview::Marker::RangeMarker->new();
$m->set_offset(30);
$m->set_north_range(10);
$m->set_south_range(10);

This will render the marker 

 Chr
 |
 |_             _
 | |             | north range
 | |___marker   _|
 | |             |
 | |             | south range
 |-             -
 |


=head1 AUTHOR

Lukas Mueller (lam87@cornell.edu)

=head1 FUNCTIONS

This class implements the following functions:

=cut

use strict;
use CXGN::Cview::Marker;
use CXGN::Cview::Label::RangeLabel;

package CXGN::Cview::Marker::RangeMarker;

use base qw / CXGN::Cview::Marker /;

=head2 function new

  Synopsis:	
  Arguments:	
  Returns:	
  Side effects:	
  Description:	

=cut

sub new {
    my $class = shift;
    my $self = $class -> SUPER::new(@_);
    
    my $range_label = CXGN::Cview::Label::RangeLabel->new();
    $range_label->set_horizontal_offset($self->get_label()->get_horizontal_offset());
    $range_label->set_vertical_offset($self->get_label()->get_vertical_offset());
    $range_label->set_name($self->get_label()->get_name());
    $range_label->set_reference_point($self->get_label()->get_reference_point());
    $range_label->set_enclosing_rect($self->get_label()->get_enclosing_rect());
    $self->set_label($range_label);

    $self->get_label()->set_stacking_level(1);
    $self->set_label_side("right");
    $self->set_hilite_chr_region(0);
    $self->set_region_hilite_color(100, 100, 150);
    return $self;
}

=head2 functions get_north_range(), set_north_range()

  Synopsis:	$m->get_north_range()
  Arguments:	setter: the north range of the range marker
                        in the units of the map
  Returns:	getter: the north range
  Side effects:	the markers range drawn on the northern side
                reflects this value
  Description:	

=cut

sub get_north_range { 
    my $self=shift;
    return $self->{north_range};
}


sub set_north_range { 
    my $self=shift;
    my $cM = shift;
    $self->{north_range}=$cM;
    
}

=head2 functions get_south_range(), set_south_range()

  Synopsis:	see north range
  Arguments:	
  Returns:	
  Side effects:	
  Description:	

=cut

sub get_south_range { 
    my $self=shift;

    return $self->{south_range};
}

sub set_south_range { 
    my $self=shift;
    my $cM = shift;
    $self->{south_range}=$cM;

    
}

sub render { 
    my $self = shift;
    my $image = shift;

    # calculate the pos in pixels of the northern range limit
    #
    my $north_pixels = $self->get_chromosome()->mapunits2pixels($self->get_offset()) + $self->get_chromosome()->get_vertical_offset() - $self->get_chromosome()->mapunits2pixels($self->get_north_range());
    
    # determine the pixels of the southern limit
    #
    my $south_pixels = $self->get_chromosome()->mapunits2pixels($self->get_offset()) + $self->get_chromosome()->get_vertical_offset() + $self->get_chromosome()->mapunits2pixels($self->get_south_range());
#    print STDERR "cM = ".$self->get_north_range().", pixels= $north_pixels\n";
#    print STDERR "cM = ".$self->get_south_range().", pixels= $south_pixels\n";

    $self->get_label()->set_north_position($north_pixels);
    $self->get_label()->set_south_position($south_pixels);
    my $halfwidth = int($self->get_chromosome()->get_width()/2);
    if ($self->get_label_side() eq "right") { 
	$self->get_label()->set_reference_point($self->get_chromosome()->get_horizontal_offset()+$halfwidth+$self->get_label()->get_stacking_height()*($self->get_label()->get_stacking_level()), int(($north_pixels+$south_pixels)/2));
    }
    elsif ($self->get_label_side() eq "left") { 
	$self->get_label()->set_reference_point($self->get_chromosome()->get_horizontal_offset()-$halfwidth-$self->get_label()->get_stacking_height()*$self->get_label()->get_stacking_level(), int(($north_pixels+$south_pixels)/2));
    }
    else { 
	die "[RangeMarker.pm] label_side can either be right or left. Sorry.";
    }
    if ($self->get_hilite_chr_region()) { 
	$self->hilite_chr_region($image);
    }
    
    $self->get_offset_label()->set_label_text($self->get_offset());
    # draw the offset on the right if label_side eq left, if display_marker
   #  # offset is true in the chromosome object
#     #
#     if ($self->get_chromosome()->{display_marker_offset}) { 
	
# 	# define the label's reference point
# 	#
# 	my $offset_label = $self->get_offset_label();
# 	$offset_label->set_reference_point($self->get_chromosome()->get_horizontal_offset()+$halfwidth, int(($north_pixels+$south_pixels)/2));
# 	$offset_label->set_horizontal_offset($self->get_chromosome()->get_horizontal_offset()+ $self->get_label()->get_label_spacer() );
# 	$offset_label->set_vertical_offset($self->get_label()->get_vertical_offset());
# 	$offset_label->set_align_side("left");
	
# 	$offset_label->set_hidden($self->get_label()->is_hidden());
# 	$offset_label->render($image);
#     }
    

    $self->SUPER::render($image);
}


=head2 accessors set_region_hilite_color, get_region_hilite_color

  Property:	
  Setter Args:	
  Getter Args:	
  Getter Ret:	
  Side Effects:	
  Description:	

=cut

sub get_region_hilite_color { 
    my $self=shift;
    return @{$self->{region_hilite_color}};
}

sub set_region_hilite_color { 
    my $self=shift;
    @{$self->{region_hilite_color}}= (shift, shift, shift);
}



=head2 accessors set_hilite_chr_region(), get_hilite_chr_region()

  Property:	
  Setter Args:	
  Getter Args:	
  Getter Ret:	
  Side Effects:	
  Description:	

=cut

sub get_hilite_chr_region { 
    my $self=shift;
    return $self->{hilite_chr_region};
}

sub set_hilite_chr_region { 
    my $self=shift;
    $self->{hilite_chr_region}=shift;
}



sub hilite_chr_region { 
    my $self = shift;
    my $image = shift;
    
    my $north_pixels = $self->get_label()->get_north_position();
    my $south_pixels = $self->get_label()->get_south_position();

    # hilite only regions that are visible
    # 
    if ($north_pixels < 0) { $north_pixels = 0; }
    my $chr_end_pixels = ($self->get_chromosome()->get_height()+$self->get_chromosome()->get_vertical_offset()); 
    if ($north_pixels > $chr_end_pixels) { 
	$north_pixels = $chr_end_pixels;
    }

    my $left_pixels =  $self->get_chromosome()->get_horizontal_offset()-$self->get_chromosome()->get_width()/2+1;
    my $right_pixels = $self->get_chromosome()->get_horizontal_offset()+$self->get_chromosome()->get_width()/2-1;
 
    #print STDERR  "North: $north_pixels South: $south_pixels. left: $left_pixels. Right: $right_pixels\n";
       
    $image->filledRectangle($left_pixels, $north_pixels, $right_pixels, $south_pixels, $image->colorAllocate($self->get_region_hilite_color()));
}

sub draw_tick { 
    my $self = shift;
    my $image = shift;
    my $color = $image -> colorResolve($self->get_color());
    my $halfwidth = int($self->get_chromosome->get_width/2);
    my $north_y = $self->get_chromosome()->get_vertical_offset() + $self->get_chromosome()->mapunits2pixels($self->get_offset()-$self->get_north_range());

    my $south_y = $self->get_chromosome()->get_vertical_offset() + $self->get_chromosome()->mapunits2pixels($self->get_offset()+$self->get_south_range());

    if ($self->get_show_tick()) { 	
	$image -> line($self->get_chromosome()->get_horizontal_offset() - $halfwidth +1, $north_y, $self->get_chromosome()->get_horizontal_offset()+$halfwidth-1, $north_y, $color);
	$image -> line($self->get_chromosome()->get_horizontal_offset() - $halfwidth +1, $south_y, $self->get_chromosome()->get_horizontal_offset()+$halfwidth-1, $south_y, $color);
    }
}


return 1;

