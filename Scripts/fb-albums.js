// FB app
window.fbAsyncInit = function() {
  
  FB.init({
    appId      : '482666868430182', // App ID
    channelUrl : 'http://pineridgechamber.com/_fb-channel.php', // Channel File
    status     : true, // check login status
    cookie     : true, // enable cookies to allow the server to access the session
    xfbml      : true  // parse XFBML
  });
  
  fbAlbums();
  fbAlbum();
  
};

(function(d){
  //Load the SDK Asynchronously
  var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
  if (d.getElementById(id)) {return;}
  js = d.createElement('script'); js.id = id; js.async = true;
  js.src = "//connect.facebook.net/en_US/all.js";
  ref.parentNode.insertBefore(js, ref);
}(document));

function fbAlbums() {
  
  // Display the album
  $('.fb-albums').each(function(index, element){
    
    var entityID = $(element).attr('id');
    var container = '#' + entityID;
    FB.api(entityID + '/albums', function(fbAlbums){

      // Tabs
      var tabContents = [];

      // Entity albums
      $(container + ' .graceful').remove();
      
      var albums = [];
      for (albumIdx in fbAlbums.data) {
        var album = fbAlbums.data[albumIdx];
        if (album.cover_photo) {
          albums.push(album);
        }
        else {
          // Skip albums that are missing a cover photo
        }
      }      
      
      for (albumIdx in albums) {
        
        // Each album
        var album = albums[albumIdx];
        var template = $($('#fb-albums-template').html());
        template.find('.fb-album-name').html(album.name);
        template.find('.fb-album-cover-photo').attr('id', album.cover_photo);
        template.find('.fb-link').attr('href', album.link);

        // Add to tab content
        if (albumIdx % 4 == 0) {
          tabContents.unshift(''); }
        tabContents[0] += template.wrap('<div>').parent().html();
        
      }

      // Prepare tabs
      var tabData = [];
      for (tabIdx in tabContents.reverse()) {
        tabData.push({tab: parseInt(tabIdx) + 1, panel: tabContents[tabIdx]});
      }
      var tabRendered = $(tabElement(tabData, entityID));
      tabRendered.tabs();
      
      // Add content
      $(container).append(tabRendered);
      
      // Collect IDs
      var ids = [];
      $('.fb-album-cover-photo').each(function(){
        ids.push($(this).attr('id'));
      });
      
      FB.api('?ids='+ids.join(','), function(photos){
        for (photoIdx in photos) {
          var photo = photos[photoIdx];
          $('.fb-album-cover-photo#'+photoIdx).attr('src', photo.picture);
        }
      });
      
    });
  });
  
}

function fbAlbum() {
  // Display the album
  $('.fb-album .graceful').remove();
  $('.fb-album').each(function(index, element){
    var albumID = $(element).attr('id');
    fbAlbumHelper(albumID + '/photos', albumID);
  });
}

function fbAlbumHelper(graphCall, albumID) {
  FB.api(graphCall, function(response){
    for (photoIdx in response.data) {
      var photo = response.data[photoIdx];
      var picture = $($('#fb-album-template').html());
      $(picture).find('.fb-link').attr('href', photo.link);
      $(picture).find('.fb-photo').attr('src', photo.images[6].source);
      $(picture).find('.fb-photo-name').html(photo.name);
       $('#' + albumID).append(picture);
    }
    if (response.paging.next) {
      fbAlbumHelper(response.paging.next, albumID);
    }
  });
}

/**
 * 
 * @param data = [{tab:'', panel:''}, ...];
 * @returns
 */
function tabElement (tabData, prefix) {

  // Labels
  var labels = '<ul><div class="pages">Pages:</div>';
  for (tabIndex in tabData) {
    var tabId = prefix + '-' + tabIndex;
    var section = tabData[tabIndex];
    labels += '<li><a href="#' + tabId + '">' + section.tab + '</a></li>';
  }
  labels += '</ul>';

  // Content
  var content = '';
  for (tabIndex in tabData) {
    var tabId = prefix + '-' + tabIndex;
    var section = tabData[tabIndex];
    content += '<div id="' + tabId + '" class="clearfix">' + section.panel + '</div>';
  }

  // Tabs container
  var containerId = prefix + '-' + 'tabs';
  var container = '<div id="' + containerId + '">' + labels + content + '</div>';
  
  return container;
  
}
