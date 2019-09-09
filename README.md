# quantum_swift

Yet another quantum simulator. This time it is in Swift. Internally it is backed by a sparse binary tree. That is,
if entire branches are zeroed out then those branches are pruned off. This does mean that more space is
used when your qubits are in _full_ superposition, but it makes other states take up less space. It also
makes some operations easier. For example, checking whether qubits are actually ready to be released or
borrowing new qubits. More on that to come.

To create an xcodeproject for this package type `swift package generate-xcodeproj`.
