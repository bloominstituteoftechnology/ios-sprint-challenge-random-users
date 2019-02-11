import Foundation

struct Results: Decodable {
    let results: [RandomPerson]
}

struct RandomPerson: Decodable {
    
    var results: [String] = []
    var name: String = ""
    //var first: String = ""
    //var last: String = ""
    var email: String = ""
    var phone: String = ""
    //var picture: [String] = []
    var thumbnail: String = ""
    var large: String = ""
    var resultsCount: Int = 0

    enum RandomPeopleCodingKeys: CodingKey {
        case results
        case info
        
        enum InfoCodingKeys: String, CodingKey {
            case seed
            case resultsCount = "results"
        }
        
        enum RandomPersonDescription: String, CodingKey {
            case name
            case email
            case phone
            case picture
            
            enum Name: String, CodingKey {
                case first
                case last
            }
            
            enum Picture: String, CodingKey {
                case large
                case thumbnail
            }
        }
    }
    
    struct Results: Decodable {
        let results: [RandomPerson]
    }
    
    init(from decoder: Decoder) throws {
        //properties
        
        //var randomPeopleArray: [String] = []
        //var pictureArray: [String] = []
        var nameArray: [String] = []
        var firstName: String = ""
        var lastName: String = ""
        var thumbnailImg: String = ""
        var largeImg: String = ""
        
        
        //outermost container
        let container = try decoder.container(keyedBy: RandomPeopleCodingKeys.self)
        
        //results level
        var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)
        
        //while !resultsContainer.isAtEnd {
            //get each random person attribute
            
            //random person description level
            let randomPersonDescriptionContainer = try resultsContainer.nestedContainer(keyedBy: RandomPeopleCodingKeys.RandomPersonDescription.self)
            
            //name level
            let nameContainer = try randomPersonDescriptionContainer.nestedContainer(keyedBy: RandomPeopleCodingKeys.RandomPersonDescription.Name.self, forKey: .name)
            
            //finally we can grab those deets
            firstName = try nameContainer.decode(String.self, forKey: .first)
            lastName = try nameContainer.decode(String.self, forKey: .last)
            nameArray.append(contentsOf: [firstName, lastName])
            name = (nameArray.joined(separator: " ").capitalized)
            nameArray = []
            //print(name)
            
            
            //picture level
            let pictureContainer = try randomPersonDescriptionContainer.nestedContainer(keyedBy: RandomPeopleCodingKeys.RandomPersonDescription.Picture.self, forKey: .picture)
            //finally we can grab those deets
            thumbnailImg = try pictureContainer.decode(String.self, forKey: .thumbnail)
            largeImg = try pictureContainer.decode(String.self, forKey: .large)
            //pictureArray.append(contentsOf: [thumbnailImg, largeImg])
            thumbnail = thumbnailImg
            large = largeImg
            //picture = pictureArray
            //pictureArray = []
            
            email = try randomPersonDescriptionContainer.decode(String.self, forKey: .email)
            phone = try randomPersonDescriptionContainer.decode(String.self, forKey: .phone)
            //FIXME: - Data structure to construct random person object with properties and append to results
            
            
        } //end while
        
    }
    
}
