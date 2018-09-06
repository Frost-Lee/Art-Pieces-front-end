# Art-Pieces-front-end

__This is a project for contest use, before its release, you should NOT use the project's code anywhere__

![](https://cl.ly/307d9c6e3ce1/IMG_0120.PNG)

[Backend Hyperlink](https://github.com/ZJUGuoShuai/ArtPieces-Back-end)

## Data Structure

#### Artwork
One of the most primary data structure is `Artwork`, which represents an artwork, including the id, keyPhoto, creator email, timestamp, and the id of its belonging repository. The keyPhoto of the artwork could be imported from system album, or exported from an existed Artboard.
``` Swift
struct Artwork {
	var id: UUID
	var keyPhotoURL: URL
	var creatorEmail: String
	var belongingRepoID: UUID?
	var timestamp: Date
}
```

#### Repository
`Repository` is the collection of Artworks, with a key `Artwork`, people can contribute their own `Artwork` at the similar theme into the Repository.
``` Swift
struct Repository {
	var id: UUID
	var keyArtworkID: UUID
	var contentArtworksID: [UUID]
	var creatorEmail: String
	var timestamp: Date
}
```

#### Artboard
Since Art Pieces give users the chance of creating an entire artwork within quitting the app, as well as recording the step of finishing the artwork in order to help new comers to learn painting, `Artboard` is the structure that records an painting and its step records. `Artboard` can be stored locally, or published as an `Artwork` or a `Lecture`.
``` Swift 
struct Artboard {
	var id: UUID
	var keyPhoto: UIImage
	var creatorEmail: String
	var content: Data
	var timestamp: Date
}
```

#### Lecture
`Lecture` are the published `Artboard` with step records, users can download the lectures and see the detailed steps of drawing a magnificant artwork.
``` Swift
struct Lecture {
	var id: UUID
	var keyPhotoURL: URL
	var creatorEmail: String
	var content: Data
	var timestamp: Date
}
```

#### User
``` Swift
struct User {
	var email: String
	var password: String
	var portraitURL: URL
}
```

## To-Dos
#### Artboard Rendering
- [ ] Layer control of `Artboard`
- [ ] Width fixes of pen and erasers
- [ ] Transparency control of pens
- [ ] Withdrawable strokes
- [ ] More textures of pens
- [ ] Popover redesign of tool bar

#### Data Structure Redesign
- [ ] Only use `Artboard` in local storage
- [ ] PersonalViewController should present online Artworks instead of local ones
- [ ] Create another space for local `Artboard`
- [ ] Maybe .xib files could be used in a more elegant way

#### Others
- [ ] Accessibility (Voice Over, etc.)
- [ ] Environment checks (Is network available, is allowed to view system album, etc.)



