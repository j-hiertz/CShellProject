#ifndef __HANDLER_H__
#define __HANDLER_H__

/**
 * Handle the rootNode and call executer to execute the commands
 * 
 * \param strcut Node* rootNode of the tree
 * \return void
 */
void handle(Node *rootNode);

/**
 * Handle command using a pipe
 * 
 * \param Node *nodeInput node in input of the pipe
 * \param Node *nodeOutput node in output of the pipe
 * \return void
 */
void handlePipe(Node *nodeInput, Node *nodeOutput);

/**
 * Handle command using < and <<
 * 
 * \param Node *node command
 * \param char *file path to create file
 * \param char *mode to open file
 */
void handleRightRedirection(Node *node, char *file, char *mode);
#endif /** __HANDLER_H__ **/