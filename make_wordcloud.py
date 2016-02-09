
"""
Minimal Example
===============
Generating a square wordcloud from the US constitution using default arguments.
"""

from os import path
import matplotlib.pyplot as plt
from wordcloud import WordCloud

d = path.dirname(__file__)

# Read the whole text.
#text = open(path.join(d, 'teststring.txt')).read()
text = "automat automat automat sensor sensor output"
wordcloud = WordCloud().generate(text)
# Open a plot of the generated image.
plt.imshow(wordcloud)
plt.axis("off")
plt.show()

# C:\Users\Puettmann\Anaconda3\envs