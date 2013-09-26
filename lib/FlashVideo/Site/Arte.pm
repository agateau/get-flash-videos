# Part of get-flash-videos. See get_flash_videos for copyright.
package FlashVideo::Site::Arte;

use strict;
use FlashVideo::Utils;
use FlashVideo::JSON;

sub find_video {
  my ($self, $browser, $embed_url, $prefs) = @_;
  my ($lang, $filename, $videourl);

  debug "Arte::find_video called, embed_url = \"$embed_url\"\n";

  my $pageurl = $browser->uri() . "";
  if($pageurl =~ /www\.arte\.tv\/guide\/(..)\//) {
    $lang = $1;
  } else {
    die "Unable to find language in original URL \"$pageurl\"\n";
  }

  my $jsonurl;
  if($browser->content =~ /arte_vp_url="(.*)"/) {
    $jsonurl = $1;
  } else {
    die "Unable to find 'arte_vp_url' in page\n";
  }
  $browser->get($jsonurl);

  my $json = from_json($browser->content);
  my $entry;
  $entry = $json->{videoJsonPlayer}->{VSR}->{RTMP_SQ_1};

  $videourl = {
    rtmp => $entry->{streamer} . "mp4:" . $entry->{url}
  };
  $filename = title_to_filename($json->{videoJsonPlayer}->{VTI});
  return $videourl, $filename;
}

1;
