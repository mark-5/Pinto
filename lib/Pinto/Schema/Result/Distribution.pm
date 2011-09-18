package Pinto::Schema::Result::Distribution;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Pinto::Schema::Result::Distribution

=cut

__PACKAGE__->table("distribution");

=head1 ACCESSORS

=head2 distribution_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 path

  data_type: 'text'
  is_nullable: 0

=head2 origin

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "distribution_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "path",
  { data_type => "text", is_nullable => 0 },
  "origin",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("distribution_id");
__PACKAGE__->add_unique_constraint("path_unique", ["path"]);

=head1 RELATIONS

=head2 packages

Type: has_many

Related object: L<Pinto::Schema::Result::Package>

=cut

__PACKAGE__->has_many(
  "packages",
  "Pinto::Schema::Result::Package",
  { "foreign.distribution" => "self.distribution_id" },
  { cascade_copy => 0, cascade_delete => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-18 01:20:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5FGF6HitBy/iY67FoILI4Q

#-------------------------------------------------------------------------------

use URI;
use Path::Class qw();

use overload ('""' => 'to_string');

#------------------------------------------------------------------------------

sub physical_path {
    my ($self, @base) = @_;

    my @parts = split '/', $self->location();

    return Path::Class::file(@base, qw(authors id), @parts);
}

#------------------------------------------------------------------------------

sub url {
    my ($self, $base) = @_;

    return URI->new( "$base/authors/id/" . $self->path() )->canonical();
}

#------------------------------------------------------------------------------

sub package_count {
    my ($self) = @_;

    return scalar $self->packages();
}

#------------------------------------------------------------------------------

sub to_string {
    my ($self) = @_;

    return $self->path();
}

#------------------------------------------------------------------------------

1;

__END__
