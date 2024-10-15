# nkauj_qhuas_vajtswv

A new Flutter project.

## Hide appbar
appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: searchAble
            ? TextField(
                controller: searchTextController,
                onChanged: (value) {
                },
              )
            : Text(
                widget.title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
        leading: searchAble
            ? Container(
                child: IconButton(
                  onPressed: () {
                    if (searchTextController.text.isNotEmpty ) {
                    }
                  },
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.grey.withOpacity(0.5),
                  radius: 15,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Platform.isAndroid
                        ? Icon(Icons.arrow_back)
                        : Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                  ),
                ),
              ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  searchAble = !searchAble;
                });
              },
              icon: Icon(
                searchAble ? Icons.close : Icons.search,
                color: Colors.black,
                size: 28,
              ))
        ],
      ),
