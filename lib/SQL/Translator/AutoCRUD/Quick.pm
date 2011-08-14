package SQL::Translator::AutoCRUD::Quick;

use strict;
use warnings FATAL => 'all';

{
    package SQL::Translator::AutoCRUD::Quick::Source;

    sub new {
        my ($class, $self) = @_;
        return bless $self, $class;
    };

    sub f {
        my $self = shift;
        return $self->{cpac_f} if $self->{cpac_f};
        $self->{cpac_f} = { map {($_->name => $_)} ($self->get_fields) };
        return $self->{cpac_f};
    }

    package SQL::Translator::AutoCRUD::Quick::Table;
    use base qw/SQL::Translator::AutoCRUD::Quick::Source
        SQL::Translator::Schema::Table/;

    sub is_view { 0 }

    package SQL::Translator::AutoCRUD::Quick::View;
    use base qw/SQL::Translator::AutoCRUD::Quick::Source
        SQL::Translator::Schema::View/;

    sub is_view { 1 }
}

use base 'SQL::Translator::Schema';

sub new {
    my ($class, $self) = @_;
    return bless $self, $class;
};

sub t {
    my $self = shift;
    return $self->{cpac_t} if $self->{cpac_t};
    $self->{cpac_t} = {
        (map {($_->name => SQL::Translator::AutoCRUD::Quick::Table->new($_))}
            $self->get_tables),
        (map {($_->name => SQL::Translator::AutoCRUD::Quick::View->new($_))}
            $self->get_views),
    };
    return $self->{cpac_t};
}

1;