#include <SFML/Graphics.hpp>
#include <iostream>
#include <assert.h>

const int JE = 0x74;
const int Ins_place = 18;
const int TrueHash = 7087220;

bool check_tap_button(sf::Vector2i mousePos, sf::Event event, sf::RectangleShape button);
int hash_file(char* buff, int file_size);
bool patch_file(const char* filename);


class img {
private:
	sf::Image image;
	sf::Texture texture;
public:	
	sf::Sprite sprite;

	img(const char* pict, int x, int y) {
		image.loadFromFile(pict);
		texture.loadFromImage(image);
		sprite.setTexture(texture);
		sprite.setPosition(x, y);
	}
};

class text {
private:
	sf::Font font;
public:
	sf::Text msg;

	text(const char* font_loc, int font_size, const char* s, int x, int y) {
		font.loadFromFile(font_loc);
		msg.setStyle(sf::Text::Bold);
		msg = sf::Text(s, font, font_size);
		msg.setPosition(x, y);
	}
};


int main(){
	sf::RenderWindow window(sf::VideoMode(500, 400), "hack");

	text hack = text("CyrilicOld.ttf", 50, "hack", 200, 320);
	sf::RectangleShape button(sf::Vector2f(300, 100));
	button.setFillColor(sf::Color(255, 0, 0));
	img pirate = img("pirate.jpg", 0, 0);

	while (window.isOpen()){
		sf::Event event;
		while (window.pollEvent(event)){
			if (event.type == sf::Event::Closed)
				window.close();

			if (check_tap_button(sf::Mouse::getPosition(window), event, button)) {
				if (patch_file("W:\\TOBEHACK.com"))
					button.setFillColor(sf::Color(0, 255, 0));

			}
		}
		window.clear();

		window.draw(pirate.sprite);
		button.setPosition(100, 300);
		window.draw(button);
		window.draw(hack.msg);
		
		window.display();
	}
} 

bool check_tap_button(sf::Vector2i mousePos, sf::Event event, sf::RectangleShape button) {
	if (event.type == sf::Event::MouseButtonPressed)
		if (event.key.code == sf::Mouse::Left)
			if (button.getGlobalBounds().contains(mousePos.x, mousePos.y)) {
				std::cout << "pressed\n";
				return true;
			}
	return false;
}

int hash_file(char* buff, int file_size) {
	assert(buff);

	int hash = 0;
	for (int i = 0; i < file_size; ++i) {
		hash += buff[i] * i * 31;
	}
	return hash;
}

bool patch_file(const char* filename) {
	assert(filename);

	FILE* prog = NULL;
	fopen_s(&prog,filename, "r");
	assert(prog);
	FILE* patch = NULL;
	fopen_s(&patch, "W:\\TOBEHACK_PATCH.com", "wb");
	assert(patch);

	fseek(prog, 0, SEEK_END);
	int file_size = ftell(prog);
	fseek(prog, 0, SEEK_SET);

	char* buff = new char[file_size];
	assert(buff);

	fread(buff, sizeof(char), file_size, prog);

	int hash = hash_file(buff, file_size);
	if (hash != TrueHash) {
		std::cout << "WRONG FILE";
		return false;
	}

	buff[Ins_place] = JE;

	fwrite(buff, sizeof(char), file_size, patch);
	fclose(prog);
	fclose(patch);
	return true;
}
