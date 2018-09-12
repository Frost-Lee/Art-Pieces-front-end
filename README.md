# Art Pieces

"The very redefinition of creating and sharing."

___

![](https://cl.ly/307d9c6e3ce1/IMG_0120.PNG)

___

There are a thousand Hamlet in the eyes of a thousand people. It's true that everyone would have their own idea of painting of a topic. Art Pieces intend to build the place where everyone can contribute their own creation under a specific topic. By starting a repository, one can add their initial artwork of the idea, by forking the repository, everyone can give their different artwork under the same topic.
Besides, Art Pieces provides a brand new drawing system - Artboard, which can not only enable you to start your painting without quitting the app, but help you to record the specific step of finishing the artwork. If you feel like so, you can publish your artboard as a Lecture, so that others could not only see what your artwork looks like, but how it's done.

___

![](https://cl.ly/cee8dc911371/ScreenShot.jpg)

#### Features
- Create a repository and inspire everyone to create their own artwork under the theme
- Upload your own artwork to related repository
- Download Lecture and see how a magnificent artwork is done
- Use artboard to draw your own artwork and save it on the device
- Use step recorder to record each step you finish the artboard
- Upload your artboard as lecture to guide new comers

__Contact us at feedback@artpieces.cn for support, or start an issue to report a bug__

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
	var uuid: UUID
	var timestamp: Date
	var creatorEmail: String
	var title: String
	var boardDescription: String
	var keyPhotoPath: String
	var stepPreviewPhotoPath: String
	var content: Data
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
- [x] Only use `Artboard` in local storage
- [ ] PersonalViewController should present online Artworks instead of local ones
- [x] Create another space for local `Artboard`
- [ ] Maybe .xib files could be used in a more elegant way

#### Others
- [ ] Accessibility (Voice Over, etc.)
- [ ] Environment checks (Is network available, is allowed to view system album, etc.)
- [ ] Multi-language support (Chinese, most importantly)


