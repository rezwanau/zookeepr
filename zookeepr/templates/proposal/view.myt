<h2><% c.proposal.title | h %></h2>

<div id="proposal">

<p class="submitted">
Proposal for a
<% c.proposal.type.name %> 
submitted by
% for p in c.proposal.people:
<% p.firstname | h %> <% p.lastname | h %>
&lt;<% p.email_address | h %>&gt;
% #endfor
at
<% c.proposal.creation_timestamp.strftime("%Y-%m-%d&nbsp;%H:%M") %>
(last updated at <% c.proposal.last_modification_timestamp.strftime("%Y-%m-%d&nbsp;%H:%M") %>)
</p>

% if c.proposal.type.name:
<p class="url">
<em>Proposal Type:</em>
<% c.proposal.type.name %>
</p>
% #endif

<div class="abstract">
<p>
<em>Abstract:</em>
</p>
<blockquote>
<% h.line_break(h.esc(c.proposal.abstract)) %>
</blockquote>
</div>

% if c.proposal.project:
<p class="url">
<em>Project:</em>
<% c.proposal.project | h %>
</p>
% #endif

% if c.proposal.url:
<p class="url">
<em>URL:</em>
# FIXME: I reckon this should go into the helpers logic
%   if '://' in c.proposal.url:
<a href="<% c.proposal.url | h %>"><% c.proposal.url | h %></a>
%   else:
<a href="http://<% c.proposal.url | h %>"><% c.proposal.url | h %></a>
%   #endif
</p>
% #endif

% if c.proposal.abstract_video_url:
<p class="video">
<em>Video Abstract:</em>
# FIXME: I reckon this should go into the helpers logic
%   if '://' in c.proposal.abstract_video_url:
<a href="<% c.proposal.abstract_video_url | h %>"><% c.proposal.abstract_video_url | h %></a>
%   else:
<a href="http://<% c.proposal.abstract_video_url | h %>"><% c.proposal.abstract_video_url | h %></a>
%   #endif
</p>
% #endif

% for person in c.proposal.people:
<h2><% person.firstname | h%> <% person.lastname | h%></h2>
<div class="experience">
<p>
<em>Speaking experience:</em>
</p>
<blockquote>
%   if person.experience:
<% h.line_break(h.esc(person.experience)) %>
%   else:
[none provided]
%   #endif
</blockquote>
</div>

<div class="bio">
<p>
<em>Speaker bio:</em>
</p>
<blockquote>
%   if person.bio:
<% h.line_break(h.esc(person.bio)) %>
%   else:
[none provided]
%   #endif
</blockquote>
</div>
% # endfor
<p></p>
<div class="attachment">
<p><em>Attachments:</em></p>
% if len(c.proposal.attachments) > 0:
<table>
<tr>
<th>Filename</th>
<th>Size</th>
<th>Date uploaded</th>
<th>&nbsp;</th>
</tr>
% #endif

% for a in c.proposal.attachments:
<tr class="<% h.cycle('even', 'odd') %>">

<td>
<% h.link_to(h.esc(a.filename), url=h.url_for(controller='attachment', action='view', id=a.id)) %>
</td>

<td>
<% h.number_to_human_size(len(a.content)) %>
</td>

<td>
<% a.creation_timestamp.strftime("%Y-%m-%d %H:%M") %>
</td>

<td>
<% h.link_to('delete', url=h.url(controller='attachment', action='delete', id=a.id)) %>
</tr>
% #endfor

% if len(c.proposal.attachments) > 0:
</table>
% #endfor
<p>
<% h.link_to('Add an attachment', url=h.url(action='attach')) %>
</p>
</div>

<p>
% if c.proposal.assistance:
<p>
<em>Travel assistance:</em> <% c.proposal.assistance.name %></p>
% # endif
</p>

<hr />

<p class="actions">
<ul>

% if c.signed_in_person in c.proposal.people or ('organiser' in [x.name for x in c.signed_in_person.roles]):
<li>
<% h.link_to('Edit Proposal', url=h.url(action='edit',id=c.proposal.id)) %>
</li>
% #endif


# Add review link if the signed in person is a reviewer, but not if they've already reviewed this proposal
% if 'reviewer' in [x.name for x in c.signed_in_person.roles] and c.signed_in_person not in [x.reviewer for x in c.proposal.reviews]:
<li>
<% h.link_to('Review this proposal', url=h.url(action='review')) %>
</li>
% #endif

</ul>
</p>

</div>


% if ('reviewer' in [x.name for x in c.signed_in_person.roles]) or ('organiser' in [x.name for x in c.signed_in_person.roles]):
<p>
<table>
<tr>
<th># - Reviewer</th>
<th>Score</th>
<th>Rec. Stream</th>
<th>Comment</th>
</tr>

%   for r in c.proposal.reviews:
<tr class="<% h.cycle('even', 'odd') %>">
<td>
<% h.link_to("%s - %s" % (r.id, r.reviewer.firstname), url=h.url(controller='review', id=r.id, action='view')) %>
</td>

<td>
<% r.score | h %>
</td>

<td>
<% r.stream.name | h %>
</td>

<td>
<% r.comment | h %>
</td>

</tr>
%   #endfor
</table>
</p>
% #endif

# FIXME: wiki disabled
#<div id="wiki">
#<% h.wiki_here() %>
#</div>


<%method title>
<% h.truncate(c.proposal.title) %> - <% c.proposal.type.name %> proposal - <& PARENT:title &>
</%method>

