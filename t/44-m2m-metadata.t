#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';
use lib qw( t/lib );

use Test::More 'no_plan';
use JSON::XS;

# application loads
BEGIN {
    $ENV{AUTOCRUD_TESTING} = 1;
    use_ok "Test::WWW::Mechanize::Catalyst" => "TestAppM2M"
}
my $mech = Test::WWW::Mechanize::Catalyst->new;

# get metadata for the album table
$mech->get_ok( '/site/default/schema/dbic/source/album/dumpmeta', 'Get album autocrud metadata' );
is( $mech->ct, 'application/json', 'Metadata content type' );

my $response = JSON::XS::decode_json( $mech->content );

#use Data::Dumper;
#print STDERR Dumper $response;

my $expected = <<'END_EXPECTED';
{"cpac":{"global":{"default_sort":"id","frontend":"full-fat","site":"default","db":"dbic","version":"CPAC v0.00031412","backend":"Model::AutoCRUD::Backend::DBIC","table":"album"},"conf":{"dbic":{"backend":"Model::AutoCRUD::Backend::DBIC","hidden":"no","display_name":"Dbic","t":{"album":{"headings":{"artist_albums":"Artist Albums","artist_id":"Artist Ids","title":"Title","recorded":"Recorded","deleted":"Deleted","id":"Id"},"display_name":"Album","hidden_cols":{},"cols":["id","deleted","recorded","title","artist_albums","artist_id"],"create_allowed":"yes","delete_allowed":"yes","editable":1,"update_allowed":"yes","dumpmeta_allowed":"yes","hidden":"no"},"artist_album":{"headings":{"album_id":"Album Id","artist_id":"Artist Id","id":"Id"},"display_name":"Artist Album","hidden_cols":{},"cols":["id","album_id","artist_id"],"create_allowed":"yes","delete_allowed":"yes","editable":1,"update_allowed":"yes","dumpmeta_allowed":"yes","hidden":"no"},"artist":{"headings":{"artist_albums":"Artist Albums","album_id":"Album Ids","pseudonym":"Pseudonym","forename":"Forename","born":"Born","id":"Id","surname":"Surname"},"display_name":"Artist","hidden_cols":{},"cols":["id","born","forename","pseudonym","surname","artist_albums","album_id"],"create_allowed":"yes","delete_allowed":"yes","editable":1,"update_allowed":"yes","dumpmeta_allowed":"yes","hidden":"no"}}}},"meta":{"display_name":"Test App M 2 Mschema V 1 X","t":{"album":{"pks":["id"],"fields":["id","deleted","recorded","title","artist_albums","artist_id"],"model":"AutoCRUD::DBIC::Album","f":{"artist_albums":{"ref_fields":["album_id"],"fields":["id"],"extjs_xtype":"textfield","is_reverse":1,"display_name":"Artist Albums","ref_table":"artist_album","rel_type":"has_many"},"artist_id":{"via":["artist_albums","artist_id"],"extjs_xtype":"textfield","is_reverse":1,"display_name":"Artist Ids","rel_type":"many_to_many"},"id":{"extjs_xtype":"numberfield","display_name":"Id"},"title":{"extjs_xtype":"textarea","display_name":"Title"},"recorded":{"extjs_xtype":"datefield","display_name":"Recorded"},"deleted":{"extjs_xtype":"checkbox","display_name":"Deleted"}},"display_name":"Album"},"artist":{"pks":["id"],"fields":["id","born","forename","pseudonym","surname","artist_albums","album_id"],"model":"AutoCRUD::DBIC::Artist","f":{"artist_albums":{"ref_fields":["artist_id"],"fields":["id"],"extjs_xtype":"textfield","is_reverse":1,"display_name":"Artist Albums","ref_table":"artist_album","rel_type":"has_many"},"pseudonym":{"extjs_xtype":"textarea","display_name":"Pseudonym"},"album_id":{"via":["artist_albums","album_id"],"extjs_xtype":"textfield","is_reverse":1,"display_name":"Album Ids","rel_type":"many_to_many"},"forename":{"extjs_xtype":"textarea","display_name":"Forename"},"id":{"extjs_xtype":"numberfield","display_name":"Id"},"born":{"extjs_xtype":"datefield","display_name":"Born"},"surname":{"extjs_xtype":"textarea","display_name":"Surname"}},"display_name":"Artist"},"artist_album":{"pks":["id"],"fields":["id","album_id","artist_id"],"model":"AutoCRUD::DBIC::ArtistAlbum","f":{"album_id":{"ref_fields":["id"],"fields":["album_id"],"extjs_xtype":"numberfield","rel_type":"belongs_to","ref_table":"album","display_name":"Album Id"},"artist_id":{"ref_fields":["id"],"fields":["artist_id"],"extjs_xtype":"numberfield","rel_type":"belongs_to","ref_table":"artist","display_name":"Artist Id"},"id":{"extjs_xtype":"numberfield","display_name":"Id"}},"display_name":"Artist Album"}}}}}
END_EXPECTED

SKIP: {
        eval { require Lingua::EN::Inflect::Number };

        skip "Lingua::EN::Inflect::Number not installed", 1 if $@;

    is_deeply( $response, JSON::XS::decode_json($expected), 'Metadata is as we expect' );
}

#warn $mech->content;
__END__
